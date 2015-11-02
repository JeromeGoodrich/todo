require "find"

class CommandLineInterface

  def initialize(args)
    @args = args
  end

  def run

    command = @args.first
    args = @args.drop(0)
    todo = TodoList.new
      case command
        when "create"
          puts "created #{todo.create(args[1])}"
        when 'add'
          todo.add_new_item(args[1],args[2])
        when 'complete'
          todo.complete_item(args[1], args[2])
        when 'remove'
          todo.remove_item(args[1], args[2])
        when 'show'
          todo.write_file(args[0])
      end
  end
end
