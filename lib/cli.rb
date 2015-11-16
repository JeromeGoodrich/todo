require 'optparse'

class CommandLineInterface

  def initialize(args, list, out = $stdout)
    @args = args
    @todo = list
    @out = out
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

    opt_parser.parse!(@args)

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
    @out.puts e.message
  end

  private

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

  def saved_list(list)
    @out.puts "saved list #{list} to printable file"
  end

  def new_list(list)
    @out.puts "created new list: #{list}"
  end

  def added_task(task, list)
    @out.puts "added new task #{task} to list #{list}"
  end

  def completed_task(task, list)
    @out.puts "completed task #{task} in list #{list}"
  end

  def deleted_task(task, list)
    @out.puts "deleted task #{task} in list #{list}"
  end

  def deleted_list(list)
    @out.puts "deleted list #{list}"
  end
end
