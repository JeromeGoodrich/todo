

class TodoItem

end

class CommandLineInterface
end




TodoList::CLI.new(ARGV).run

class CLI
  def initialize(args)
    @args = args
  end

  def run
    command = @args.first
    args = @args.rest
    case command
    when 'new'
      TodoList.new(args.first).save
      File.new()
    when 'add'
      TodoList.new(args.first).add(args.first)
    when 'complete'

  end
end

# File formats
# txt
# csv
# yaml
