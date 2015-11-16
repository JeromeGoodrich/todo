require "rspec"
require "todo_list"

describe TodoList do
  let(:test_db) {
    db = SQLite3::Database.new "lists/lists_test.db"
    db.execute "CREATE TABLE IF NOT EXISTS Lists(id INTEGER, Name TEXT)"
    db.execute "CREATE TABLE IF NOT EXISTS Tasks(id INTEGER, list_id INTEGER, Name TEXT, Done INTEGER)"
    db
  }
  let(:list) { TodoList.new(test_db) }

  after do
    test_db.execute("DROP TABLE Lists;")
    test_db.execute("DROP TABLE Tasks;")
  end

  it "creates a list" do
    list.create("NewList")

    expect(list.lists.first[:name]).to eq("NewList")
  end

  it "raises an error if the list already exists" do
    list.create("NewList")

    expect { list.create("NewList") }.to raise_error TodoList::ListError
    expect(list.lists.count).to eq(1)
  end

  it "adds a task to the todo list" do
    list.create("NewList")
    list.add("get milk", "NewList")

    expect(list.tasks.first[:list_id]).to eq(list.lists.first[:id])
    expect(list.tasks.count).to eq(1)
  end

  it "completes a task" do
    list.create("NewList")
    list.add("get milk", "NewList")
    list.add("create test", "NewList")
    list.done("get milk", "NewList")
    list.done("2","NewList")


    expect(list.tasks.first[:done]).to eq(1)
    expect(list.tasks[1][:done]).to eq(1)
  end

  it "raises an error if the task doesn't exist" do
    list.create("NewList")

    expect { list.done("non-existent task", "NewList") }.to raise_error TodoList::ListError
    expect { list.delete("non-existent task", "NewList") }.to raise_error TodoList::ListError
  end

  it "raises an error if the task has already been done" do
    list.create("NewList")
    list.add("new task", "NewList")
    list.done("new task", "NewList")

    expect { list.done("new task", "NewList") }.to raise_error TodoList::ListError
  end

  it "deletes a task" do
    list.create("NewList")
    list.add("task", "NewList")
    list.add("another task", "NewList")
    list.delete("task", "NewList")
    list.delete("another task", "NewList")

    expect(list.tasks.first).to eq(nil)
    expect(list.tasks[1]).to eq(nil)
  end

  it "shows the list" do
    list.create("NewList")
    list.add("task", "NewList")
    display = list.show("NewList")
    display = display[0]
    display = display.join("\s")


    expect(display).to eq("1 task [ ]")
  end

  it "deletes a list" do
    list.create("NewList")
    list.delete_list("NewList")

    expect(list.lists.empty?).to eq(true)
  end

  it "saves a list to a file" do
    list.create("TestList")
    list.save_to_file("TestList")

    expect(File.exist?("lists/TestList.txt")).to eq(true)
  end
end
