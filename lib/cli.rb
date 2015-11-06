class CommandLineInterface

  def initialize(args)
    @args = args
    @todo = TodoList.new
  end

  def run
    command = @args[0]
    args = @args.drop(1)
      case command

      when "create","new","c","n"
        create_command(args[0])
      when "add","a"
        add_command(args[0], args[1])
      when "done"
        done_command(args[0], args[1])
      when "delete", "d"
        delete_command(args[0], args[1])
      when "show", "s"
        show_command(args[0])
      else
        command_help
      end
    end

  def create_command(list)
    if @todo.list_exist?(list)
      list_already_exist(list)
    else
      @todo.create(list)
      new_list(list)
    end
  end

  def add_command(task, list)
    if @todo.list_exist?(list)
      @todo.add(task, list)
      added_task(task, list)
    else
      list_error(list)
    end
  end

  def done_command(task, list)
    if @todo.list_exist?(list)
      File.open("lists/#{list}.txt", "r") do |f|
        a = f.readlines
        a.each do |line|
          if line.include?("[X] #{task}")
            task_already_done(task, list)
          elsif line.include?("#{task}")
            @todo.done(task, list)
            completed_task(task, list)
          else
            task_error(task)
            break
          end
        end
      end
    else
      list_error(list)
    end
  end

  def delete_command(task, list)
    if @todo.list_exist?(list)
      File.open("lists/#{list}.txt", "r") do |f|
        f.readlines.each do |line|
          if line.include?("#{task}")
            @todo.delete(task, list)
            deleted_task(task, list)
          else
            task_error(task)
            break
          end
        end
      end
    else
      list_error(list)
    end
  end

  def show_command(list)
    if @todo.list_exist?(list)

    else
      list_error(args[1])
    end
  end

private

  def number_the_list(list)
    File.open("lists/#{list}.txt", "r") do |f|
      num = 1
      f.each_line do |line|
        puts "#{num}.#{line}"
        num += 1
      end
    end
  end

  def list_error(list)
    puts "sorry, the list: #{list} doesn't exist"
  end

  def list_already_exist(list)
    puts "the list #{list} already exists"
  end

  def task_error(task)
    puts "sorry, the task #{task} doesn't exit"
  end

  def new_list(list)
    puts "created new list: #{list}"
  end

  def added_task(task, list)
    puts "added new task #{task} to list #{list}"
  end

  def completed_task(task, list)
    puts "completed task #{task} in list #{list}"
  end

  def task_already_done(task, list)
    puts "the task #{task} in list #{list} is already done"
  end

  def deleted_task(task, list)
    puts "deleted task #{task} in list #{list}"
  end

  def command_help
    puts "Sorry, that command does not exist. Here is a list of valid commands:"
    puts ""
    puts "use 'create', 'new', 'c' or 'n' followed by the name you want to create your file"
    puts "EX: create my_file"
    puts ""
    puts "use 'add' or 'a' to add a task to a file"
    puts "EX: add 'do laundry' my_file"
    puts ""
    puts "to mark a task as done use 'done'"
    puts "EX: done 'do laundry' my_file"
    puts ""
    puts "use 'delete' or 'd' to delete a task off a list"
    puts "EX: delete 'do laundry' my_file"
    puts ""
    puts "use 'show' or 's' to show the contents of a file"
    puts "EX: s my_file"
  end
end
