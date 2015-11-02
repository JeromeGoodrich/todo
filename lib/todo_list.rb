class TodoList

  def initialize
    @items = []
    @completed_items = []
  end

  def create(file_name)
    File.open("#{file_name}.txt","w+")
  end

  def add_new_item(item, file)
    File.open("#{file_name}.txt","a+") {|f| f.puts("#{item}")}
  end

  def complete_item(file, item)
    @completed_items << item
  end

  def item_status(item)
    @completed_items.include?(item)
  end

  def remove_item(file, item_number)
    @items.delete_at(item_number.to_i-1)
    write_file(file)
  end

  def items_to_print
    a = []
    @items.each do |item|
      if @completed_items.include?(item)
        a << "#{@list_number}.[X] #{item}\n"
      else
        a << "#{@list_number}.[ ] #{item}\n"
      end
    end
      return a
  end
end
