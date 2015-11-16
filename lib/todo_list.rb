require 'sqlite3'

class TodoList
  class ListError < StandardError
  end

  def initialize(db)
    @db = db
  end

  def lists
    records = @db.execute("SELECT * FROM Lists;")
    records.map do |record|
      {
        id: record.first,
        name: record.last,
      }
    end
  end

  def tasks
    records = @db.execute("SELECT * FROM Tasks;")
    records.map do |record|
      {
        id: record.first,
        list_id: record[1],
        name: record[2],
        done: record.last,
      }
    end
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
      @db.execute "INSERT INTO Tasks(id, list_id, Name, Done) VALUES(#{id},#{list_id},'#{task}',0)"
    end
  end

  def done(task, list)
    list_id = get_list_id(list)
    result = check_in_table(list,task)

    if list_exist(list).empty?
      raise ListError, "Can't complete #{task} because list #{list} doesn't exist"
    else
      if result.to_i == 1
        raise ListError, "Task #{task} has already been done"
      elsif result == nil
        raise ListError, "Task #{task} doesn't exist in list #{list}"
      else
        @db.execute "UPDATE Tasks SET Done=1 WHERE list_id=#{list_id} AND id=#{task.to_i} or Name='#{task}'"
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
        if row[2].to_i == 0
          row[2] = "[ ]"
        elsif row[2].to_i == 1
          row[2] = "[X]"
        end
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
        if row[2].to_i == 0
          row[2] = "[ ]"
        elsif row[2].to_i == 1
          row[2] = "[X]"
        end
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
