class TodoItem
  attr_accessor :name,:done

  def initialize(name)
    @name = name
    @done = false
  end

end
