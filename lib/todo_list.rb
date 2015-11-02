require "todo_item"

class TodoList
  attr_accessor :list

  def initialize
    @list ||= []
  end

  def create(file)
    File.open("#{file}.txt", "w")
  end

  def add(item, file)
    todo_item = TodoItem.new(item)
    File.open("#{file}.txt", "a+") {|f| f.puts "[ ] #{todo_item.name}"}
  end

  def finish(item, file)
    File.open("#{file}.txt", "r+") do |f|
      f.each_line do |line|
        if line == "[ ] #{item}"

  end

  def delete(item)
    key = @list.key(item)
    @list.delete(key)
  end
end

