class CommandLineInterface

  def initialize(args)
    @args = args
    @todo = TodoList.new
  end

  def run
    command = @args[0]
    args = @args.drop(0)
      case command
        when "create"
          puts "created new new file: #{@todo.create(args[1])}"
        when 'add'
          @todo.add(args[1], args[2])
        when 'done'
          @todo.finish(args[1], args[2])
        when 'delete'
          @todo.delete(args[1])
        when 'show'
          File.open("#{args[1]}.txt", "r") do |f|
            num = 1
            f.each_line do |line|
              puts "#{num}.#{line}"
              num += 1
            end
          end
      end
  end
end
