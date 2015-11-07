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
      when "delete_list", "dl"
        delete_list_command(args[0])
      else
        command_help
      end
     rescue => e
      puts e.message
    end

  def create_command(list)
    @todo.create(list)
    new_list(list)
  end

  def add_command(task, list)
    @todo.add(task, list)
    added_task(task, list)
  end

  def done_command(task, list)
    @todo.done(task, list)
    completed_task(task, list)
  end

  def delete_command(task, list)
    @todo.delete(task, list)
    deleted_task(task, list)
  end

  def show_command(list)
    @todo.show(list)
  end

  def delete_list_command(list)
    @todo.delete_list(list)
    deleted_list(list)
  end

private

  def new_list(list)
    puts "created new list: #{list}"
  end

  def added_task(task, list)
    puts "added new task #{task} to list #{list}"
  end

  def completed_task(task, list)
    puts "completed task #{task} in list #{list}"
  end

  def deleted_task(task, list)
    puts "deleted task #{task} in list #{list}"
  end

  def deleted_list(list)
    puts "deleted list #{list}"
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
