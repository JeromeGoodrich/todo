require "rspec"
require "todo_list"



describe TodoList do
  let(:todo) {TodoList.new}
  let(:cli) {CommandLineInterface.new(args)}
  let(:output) {StringIO.new}

  it "creates a new todo list titled work" do
    todo.name = "work"

    expect(todo.name).to eq("work")
  end

  it "creates a new item called 'get paper clips'" do
    todo.add_new_item("get paperclips")

    expect(todo.items.last).to eq("get paperclips")
  end

  it "knows whether an item is completed" do
    todo.add_new_item("get paperclips")
    todo.complete_item("get paperclips")

    expect(todo.completed_items.last).to eq(("get paperclips"))
  end

  it "removes an item from the todo list" do
    todo.add_new_item("get paperclips")
    todo.add_new_item("call mom")
    todo.remove_item(1)

    expect(todo.items).to eq(["call mom"])
  end

  it "prints the title of the list" do
    todo.name = "work"
    cli.title

    expect(output.string).to eq("work")
  end

  it "prints a numbered list of incomplete items" do
    todo.add_new_item("get paperclips")
    todo.add_new_item("call mom")
    todo.add_new_item("save the world")

    cli.list

    expect(output.string).to eq("1.[ ] get paperclips\n2.[ ] call mom\n3.[ ] save the world\n")
  end

  it "marks a completed item with an X" do
    todo.add_new_item("get paperclips")
    todo.add_new_item("call mom")
    todo.add_new_item("save the world")
    todo.complete_item("call mom")

    ui.list

    expect(output.string).to eq("1.[ ] get paperclips\n2.[X] call mom\n3.[ ] save the world\n")
  end

  it "gets an input from the user" do
    $stdin = StringIO.new("some input")

    expect(ui.get_input).to eq("some input")
  end


end


# Requirements:

# From the command line, I should be able to perform these actions:

# todo new work

# Should create a new todo list titled "work".

# todo add work 'Get paperclips'

# Should add a new todo item called 'Get paperclips'

# todo show work

# Should show the work todo list, with completed items checked, for example:

# work
# 1. [ ] Get paperclips
# 2. [X] Print that thing

# todo complete 1

# Should mark the numbered item in the todo list as complete

# todo remove 2

# Should remove the numbered item from the todo list
