require 'optparse'

class CommandLineInterface

  def initialize(args)
    @args = args
    @todo = TodoList.new
  end


  def run
    options = {}

    opt_parser = OptionParser.new do |opt|
      opt.banner = "Commands:"
      opt.separator "    create, new, c or n:             new list"
      opt.separator "    add or a:                        add task to list"
      opt.separator "    done:                            mark task as done"
      opt.separator "    delete or d:                     delete task"
      opt.separator "    show or s:                       show list"
      opt.separator "    delete_list or dl:               delete list"
      opt.separator ""
      opt.separator "Options:"

      opt.on("-l","--list LIST", "which list you want to access") do |list|
        options[:list] = list
      end

      opt.on("-t","--task TASK", "which task you want to create, alter, or delete") do |task|
        options[:task] = task
      end

      opt.on("-h","--help","help") do
        puts opt_parser
        exit
      end
    end

    opt_parser.parse!

    command = @args[0]
      case command

      when "create","new","c","n"
        create_command(options[:list])
      when "add","a"
        add_command(options[:task], options[:list])
      when "done"
        done_command(options[:task], options[:list])
      when "delete", "d"
        delete_command(options[:task], options[:list])
      when "show", "s"
        show_command(options[:list])
      when "delete_list", "dl"
        delete_list_command(options[:list])
      when "save"
        save_to_file_command(options[:list])
      else
        puts opt_parser
      end
     rescue => e
      puts e.message
  end

  def save_to_file_command(list)
    @todo.save_to_file(list)
    saved_list(list)
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

  def saved_list(list)
    puts "saved list #{list} to printable file"
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
