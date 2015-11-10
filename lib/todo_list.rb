require 'sqlite3'

class TodoList
  class ListError < StandardError
  end

  def initialize
    @db = SQLite3::Database.new "lists/lists.db"
    @db.execute "CREATE TABLE IF NOT EXISTS Lists(id INTEGER, Name TEXT)"
    @db.execute "CREATE TABLE IF NOT EXISTS Tasks(id INTEGER, list_id INTEGER, Name TEXT, Done TEXT)"
  end

  def create(list)
    if list_exist(list).empty?
      id = set_id(@db.execute "SELECT * FROM Lists")
      @db.execute "INSERT INTO Lists(id,Name) VALUES(#{id},'#{list}')"
    else
      raise ListError, "The list #{list} already exists"
    end
  end

  def add(task, list)
    if list_exist(list).empty?
      raise ListError, "Can't add #{task} to #{list} because list #{list} doesn't exist"
    else
      list_id = get_list_id(list)
      id = set_id(@db.execute "SELECT * FROM Tasks WHERE list_id=#{list_id}")
      @db.execute "INSERT INTO Tasks(id, list_id, Name, Done) VALUES(#{id},#{list_id},'#{task}','[ ]')"
    end
  end

  def done(task, list)
    list_id = get_list_id(list)
    result = check_in_table(list,task)

    if list_exist(list).empty?
      raise ListError, "Can't complete #{task} because list #{list} doesn't exist"
    else
      if result == "[X]"
        raise ListError, "Task #{task} has already been done"
      elsif result == nil
        raise ListError, "Task #{task} doesn't exist in list #{list}"
      else
        @db.execute "UPDATE Tasks SET Done='[X]' WHERE list_id=#{list_id} AND id=#{task.to_i} or Name='#{task}'"
      end
    end
  end

  def delete(task, list)
    list_id = get_list_id(list)
    result = check_in_table(list,task)

    if list_exist(list).empty?
      raise ListError, "Can't delete #{task} because list #{list} doesn't exist"
    else
      if result == nil
        raise ListError, "Task #{task} can't be deleted because it doesn't exist in list #{list}"
      else
        @db.execute "DELETE FROM Tasks WHERE list_id=#{list_id} AND id=#{task.to_i} OR Name='#{task}'"
      end
    end
  end

  def show(list)
    list_id = get_list_id(list)
    if list_exist(list).empty?
      raise ListError, "Can't show list #{list} because it doesn't exist"
    else
      rows = @db.execute "SELECT id,Name,Done FROM Tasks WHERE list_id =#{list_id}"
      rows.each do |row|
        puts row.join("\s")
      end
    end
  end

  def delete_list(list)
    list_id = get_list_id(list)
    if list_exist(list).empty?
      raise ListError, "Can't delete list #{list} because it doesn't exist"
    else
      @db.execute "DELETE FROM Tasks WHERE list_id=#{list_id}"
      @db.execute "DELETE FROM Lists WHERE Name='#{list}'"
    end
  end

  def save_to_file(list)
    list_id = get_list_id(list)
    File.open("lists/#{list}.txt", "w") do |f|
      rows = @db.execute "SELECT id,Name,Done FROM Tasks WHERE list_id =#{list_id}"
      rows.each do |row|
        f.puts row.join("\s")
      end
    end
  end

private

  def set_id(args)
    if args.empty?
      1
    else
      args.count + 1
    end
  end

  def get_list_id(list)
    x = @db.execute "SELECT id FROM Lists WHERE Name='#{list}'"
    x = x.flatten[0]
    return x
  end

  def check_in_table(list,task)
    list_id = get_list_id(list)
    x = @db.execute "SELECT Done FROM Tasks WHERE list_id=#{list_id} AND id=#{task.to_i} OR Name='#{task}'"
    x = x.flatten[0]
    return x
  end

  def list_exist(list)
    @db.execute "SELECT * FROM Lists WHERE Name='#{list}'"
  end
end
