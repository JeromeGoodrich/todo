require "spec_helper"

describe "Sinatra Todo Application" do

  after do
    List.all.destroy
    Task.all.destroy
  end

  it "should load the home page" do
    get"/"

    expect(last_response).to  be_ok
  end

  it "should load a list of existing lists" do
    post"/",{:list => 'My Todo'}

    expect(last_response.body).to include("My Todo")
  end

  it "should load the correct list page" do
    list = List.new
    list.name = 'My Todo'
    save_result = list.save
    get"/#{list.id}", {:id => list.id}

    expect(last_response).to be_ok
    expect(last_response.body).to include("My Todo")
  end

  it "should delete the list" do
    list = List.new
    list.name = 'My Todo'
    list.save

    list1 = List.new
    list1.name = 'Another Todo'
    list1.save

    delete"/#{list.id}", {:id => list.id}

    expect(last_response.status).to eq(302)
    expect(List.count).to eq(1)
  end

  it "should  create a new task" do
    list = List.new
    list.name = 'My Todo'
    list.save

    post "/1",{:task => 'get milk'}

    expect(last_response.body).to include("get milk")
  end

  it "finishes a task" do
    list = List.new
    list.name = 'My Todo'
    list.save

    task = Task.new
    task.list_id = 1
    task.name = "get_milk"
    task.done = false
    task.save

    put "/task/#{task.id}", {id: task.id}

    expect(last_response.status).to eq(302)
    expect(Task.first.done).to eq(true)
  end

  it "deletes a task" do
    list = List.new
    list.name = 'My Todo'
    list.save

    task = Task.new
    task.list_id = 1
    task.name = "get_milk"
    task.done = false
    task.save

    delete "/task/#{task.id}", {id: task.id}

    expect(last_response.status).to eq(302)
    expect(Task.count).to eq(0)
  end





  it "" do
    expect(List.count).to eq(0)
  end
end
