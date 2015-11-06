class TodoList
  class ListError < StandardError
  end

  def use_list(list, option, text=nil)
    File.open("lists/#{list}.txt", option) do |f|
      if option == "r"
      elsif option == "w"
      elsif option == "a+"
        f.puts "[ ] #{text}"
      end
    end
  end


  def create(list)
    if list_exist?(list)
      raise ListError, "The list: #{list} already exists"
    else
      use_list(list,"w")
    end
  end

  def add(task, list)
    use_list(list, "a+", task)
  end

  def done(task, list)
    if task.is_a? Numeric
      find_task_by_number(task, list)
    else
      text = File.read("lists/#{list}.txt").gsub("[ ] #{task}", "[X] #{task}")
      File.open("lists/#{list}.txt", "w") { |f| f.puts text}
    end
  end

  def delete(task, list)
    if task.is_a? Numeric
      find_task_by_number(task, list)
    else
      new_text_array = delete_task(task, list)
      File.open("lists/#{list}.txt", "w") {|f| f.puts new_text_array}
    end
  end

  def list_exist?(list)
    File.exist?("lists/#{list}.txt")
  end

  def find_task_by_number(task_number, list)
     File.open("lists/#{list}.txt", "r") do |f|
      a = f.readlines
    end
      task = a[(task_number.to_i - 1)]
      done(task, list)
  end


private

def delete_task(task, list)
    File.open("lists/#{list}.txt", "r+") do |f|
      return f.readlines.delete_if {|line| line.include?("#{task}") }
    end
  end
end

