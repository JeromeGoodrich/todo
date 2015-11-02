class CommandLineInterface

  def initialize(args)
    @args = args
    @todo = TodoList.new
  end

  def run
    command = @args[0]
    args = @args.drop(0)
      case command

      when "create","new","c","n"
        @todo.create(args[1])
        puts "created new list: #{args[1]}"


      when "add","a"
        if File.exist?("#{args[2]}.txt")
          @todo.add(args[1], args[2])
          puts "added new task #{args[1]} to list #{args[2]}"
        else
          puts "Sorry the list: #{args[2]} doesn't exist"
        end


      when "done"
        if File.exist?("#{args[2]}.txt")
          File.open("#{args[2]}.txt", "r") do |f|
            f.readlines.each do |line|
              if line.include?("[X] #{args[1]}")
                puts "That item is already done"
              elsif line.include?("#{args[1]}")
                @todo.done(args[1], args[2])
                "Completed task #{args[1]} in list #{args[2]} "
              else
                puts "Sorry the task: #{args[1]} doesn't exist"
                break
              end
            end
          end
        else
          puts "Sorry the list: #{args[2]} doesn't exist"
        end


      when "delete", "d"
        if File.exist?("#{args[2]}.txt")
          File.open("#{args[2]}.txt", "r") do |f|
            f.readlines.each do |line|
              if line.include?("#{args[1]}")
                @todo.delete(args[1], args[2])
                puts "Deleted task #{args[1]} in list #{arg[2]}"
              else
                puts "Sorry the task: #{args[1]} doesn't exist"
                break
              end
            end
          end
        else
          puts "Sorry the list: #{args[2]} doesn't exist"
        end


      when "show", "s"
        if File.exist?("#{args[2]}.txt")
          File.open("#{args[1]}.txt", "r") do |f|
            num = 1
            f.each_line do |line|
              puts "#{num}.#{line}"
              num += 1
            end
          end
        else
          puts "Sorry the list: #{args[2]} doesn't exist"
        end


      else
        puts "Sorry, that command does not exist. Here is a list of valid commands:"
        puts ""
        puts ""
        puts "use 'create', 'new', 'c' or 'n' followed by the name you want to create your file"
        puts "EX: create my_file"
        puts ""
        puts "use 'add' or 'a' to add an item to a file"
        puts "EX: add 'do laundry' my_file"
        puts ""
        puts "to mark an item as done use 'done'"
        puts "EX: done 'do laundry' my_file"
        puts ""
        puts "use 'delete' or 'd' to delete an item off a list"
        puts "EX: delete 'do laundry' my_file"
        puts ""
        puts "use 'show' or 's' to show the contents of a file"
        puts "EX: s my_file"
      end
  end
end
