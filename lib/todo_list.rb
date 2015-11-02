class TodoList

  def create(file)
    File.open("#{file}.txt", "w")
  end

  def add(item, file)
    File.open("#{file}.txt", "a+") {|f| f.puts "[ ] #{item}"}
  end

  def finish(item, file)
    text = File.read("#{file}.txt").gsub("[ ] #{item}", "[X] #{item}")
    File.open("#{file}.txt", "w") { |f| f.puts text}
  end

  def delete(item, file)
    new_text_array = delete_item(item, file)
    File.open("#{file}.txt", "w") {|f| f.puts new_text_array}
  end

private

def delete_item(item, file)
    File.open("#{file}.txt", "r+") do |f|
      return f.readlines.delete_if {|line| line.include?("#{item}") }
    end
  end
end

