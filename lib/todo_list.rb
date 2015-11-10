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
     a = @db.execute "SELECT * FROM Lists WHERE Name='#{list}'"
        if a.empty?
          id = 1
        else
          id = a.count + 1
        end
          @db.execute "INSERT INTO Lists(id,Name) VALUES(#{id},'#{list}')"
    else
      raise ListError, "The list #{list} already exists"
    end
  end

  def add(task, list)
    if list_exist(list).empty?
      raise ListError, "Can't add #{task} to #{list} because list #{list} doesn't exist"
    else
      list_id = @db.execute "SELECT id FROM Lists WHERE Name='#{list}'"
      list_id = list_id.flatten[0]

      arry = @db.execute "SELECT * FROM Tasks WHERE list_id=#{list_id}"
      if arry.empty?
        id = 1
      else
        id = arry.count + 1
      end
     @db.execute "INSERT INTO Tasks(id, list_id, Name, Done) VALUES(#{id},#{list_id},'#{task}','[ ]')"
    end
  end

  def done(task, list)
    if list_exist(list).empty?
      raise ListError, "Can't complete #{task} because list #{list} doesn't exist"
    else
      if task.to_i != 0
        list_id = @db.execute "SELECT id FROM Lists WHERE Name='#{list}'"
        list_id = list_id.flatten[0]
        @db.execute "UPDATE Tasks SET Done='[X]' WHERE list_id=#{list_id} AND id=#{task.to_i}"
      else
        list_id = @db.execute "SELECT id FROM Lists WHERE Name='#{list}'"
        list_id = list_id.flatten[0]
        @db.execute "UPDATE Tasks SET Done='[X]' WHERE list_id=#{list_id} AND Name='#{task}'"
      end
    end
  end

  def delete(task, list)
    if list_exist(list).empty?
      raise ListError, "Can't delete #{task} because list #{list} doesn't exist"
    else
      if task.to_i != 0
        list_id = @db.execute "SELECT id FROM Lists WHERE Name='#{list}'"
        list_id = list_id.flatten[0]

        @db.execute "DELETE FROM Tasks WHERE list_id=#{list_id} AND id=#{task.to_i}"
      else
        list_id = @db.execute "SELECT id FROM Lists WHERE Name='#{list}'"
        list_id = list_id.flatten[0]

        @db.execute "DELETE FROM Tasks WHERE list_id=#{list_id} AND Name='#{task}'"
      end
    end
  end

  def show(list)
    if list_exist(list).empty?
      raise ListError, "Can't show list #{list} because it doesn't exist"
    else
      list_id = @db.execute "SELECT id FROM Lists WHERE Name='#{list}'"
      list_id = list_id.flatten[0]

      rows = @db.execute "SELECT id,Name,Done FROM Tasks WHERE list_id =#{list_id}"
      rows.each do |row|
        puts row.join("\s")
      end
    end
  end

  def delete_list(list)
    if list_exist(list).empty?
      raise ListError, "Can't delete list #{list} because it doesn't exist"
    else
      @db.execute "DROP TABLE IF EXISTS #{list}"
    end
  end

private

  def use_list(list, option, text=nil)
    File.open("lists/#{list}.txt", option) do |f|
      if option == "r"
        f.readlines
      elsif option == "w"
        if text != nil
          f.puts text
        end
      elsif option == "a+"
        f.puts "[ ] #{text}"
      end
    end
  end

  def list_exist(list)
    @db.execute "SELECT * FROM Lists WHERE Name='#{list}'"
  end

  def convert_num_to_task(task_number, list)
    a = use_list(list, "r")
    task = a[(task_number.to_i - 1)]
      if task == nil
        raise ListError, "Task does not exist"
      end
    return task
  end

  def add_task_by_number(task_number, list)
      task = convert_num_to_task(task_number, list)
      if task.include?("[X]")
        raise ListError, "Task is already completed"
      else
        task.slice! "[ ] "
        done(task, list)
      end
  end

  def add_task_by_name(task, list)
    a = use_list(list, "r")
    if a.index.include?(task)
      a.each do |line|
        if line.include?("#{task}")
          if line.include?("[X]")
            raise ListError, "Task is already completed"
          else
            text = File.read("lists/#{list}.txt").gsub("[ ] #{task}", "[X] #{task}")
            use_list(list, "w", text)
            break
          end
        end
      end
    else
      raise ListError, "Can't complete #{task} because it doesn't exist"
    end
  end

  def delete_task_by_number(task_number, list)
    task = convert_num_to_task(task_number, list)
    task.slice! "[ ] "
    delete(task, list)
  end

  def delete_task(task, list)
    a = use_list(list, "r")
      if a.index.include?(task)
        a.delete_if {|line| line.include?("#{task}") }
      else
        raise ListError, "Can't delete #{task} because it doesn't exist"
      end
  end
end
