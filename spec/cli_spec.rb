require "rspec"
require "cli"

describe CommandLineInterface do
  class MockList; end

  let(:out) { StringIO.new }
  let(:list) { MockList.new }


  it "handles the new list command" do
    args = ["new", "--list", "MyList"]
    cli = CommandLineInterface.new(args,list, out)

    expect(list).to receive(:create).with("MyList")

    cli.run
  end

  it "handles the add task command" do
    args = ["add", "-l", "MyList", "-t", "task"]
    cli = CommandLineInterface.new(args,list, out)

    expect(list).to receive(:add).with("task","MyList")

    cli.run
  end

  it "handles the done command" do
    args = ["done","-l", "MyList", "-t", "task"]
    cli = CommandLineInterface.new(args, list, out)

    expect(list).to receive(:done).with("task", "MyList")

    cli.run
  end

  it "handles the delete command" do
    args = ["delete", "-l", "MyList", "-t", "task"]
    cli = CommandLineInterface.new(args, list, out)

    expect(list).to receive(:delete).with("task", "MyList")

    cli.run
  end

  it "handles the show command" do
    args = ["show", "-l", "MyList"]
    cli = CommandLineInterface.new(args, list, out)

    expect(list).to receive(:show).with("MyList")

    cli.run
  end

  it "handles the delete_list command" do
    args = ["delete_list", "-l", "MyList"]
    cli = CommandLineInterface.new(args, list, out)

    expect(list).to receive(:delete_list).with("MyList")

    cli.run
  end

  it "handles the save command" do
    args =["save", "-l", "MyList"]
    cli = CommandLineInterface.new(args, list, out)

    expect(list).to receive(:save_to_file).with("MyList")

    cli.run
  end
end
