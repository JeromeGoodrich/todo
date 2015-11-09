class TodoList
  class ListError < StandardError
  end

  def create(list)
    if list_exist?(list)
      raise ListError, "The list #{list} already exists"
    else
      use_list(list,"w")
    end
  end

  def add(task, list)
    if list_exist?(list)
      use_list(list, "a+", task)
    else
      raise ListError, "Can't add #{task} to #{list} because list #{list} doesn't exist"
    end
  end

  def done(task, list)
    if list_exist?(list)
      if task.to_i != 0
        add_task_by_number(task, list)
      else
        add_task_by_name(task, list)
      end
    else
      raise ListError, "Can't complete #{task} because list #{list} doesn't exist"
    end
  end

  def delete(task, list)
    if list_exist?(list)
      if task.to_i != 0
        delete_task_by_number(task, list)
      else
        text = delete_task(task, list)
        use_list(list, "w", text)
      end
    else
      raise ListError, "Can't delete #{task} because list #{list} doesn't exist"
    end
  end

  def show(list)
    if list_exist?(list)
      a = use_list(list, "r")
      if a.empty?
        raise ListError, "No tasks have been added to #{list} yet"
      else
        a.each_with_index do |line, index|
          puts "#{index+1}.#{line}"
        end
      end
    else
      raise ListError, "Can't show list #{list} because it doesn't exist"
    end
  end

  def delete_list(list)
    if list_exist?(list)
      File.delete("lists/#{list}.txt")
    else
      raise ListError, "Can't delete list #{list} because it doesn't exist"
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

  def list_exist?(list)
    File.exist?("lists/#{list}.txt")
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
