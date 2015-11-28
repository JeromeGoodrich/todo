require "spec_helper"

describe "Sinatra Todo Application" do

  let (:user) { User.create(name: "Jerome", password: "12341234") }
  let (:list) { List.create(name: "New List", user_id: "#{user.id}") }
  let (:task) { Task.create(name: "New Task", list_id: "#{list.id}") }

  after :each do
    List.all.destroy
    Task.all.destroy
    User.all.destroy
  end

  describe "GET /" do
    it "should load the home page" do
      get "/"

      expect(last_response).to be_ok
    end
  end

  describe "POST /sign_up" do
    it "should sign up a new user" do
      post "/sign_up", {:user => {name: "J", password: "12341234"}}

      expect(last_response.status).to be(302)
    end

    it "should create a new user" do
      post "/sign_up", {:user => {name: "J", password: "12341234"}}

      expect(User.count).to eq(1)
      expect(User.last.password).to eq("12341234")
      expect(User.last.name).to eq("J")
    end
  end

  describe "POST /sign_in (user exists)" do
    before :each do
      post "/sign_in", {:user => {name: "Jerome", password: "12341234"}}, {"rack.session" => {current_user: "#{user.id}"} }
    end

    it "should sign in an existing user" do

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_request.path).to eq("/user/#{user.id}")
    end

    it "sets the correct current_user for the session" do

      expect(last_request.env['rack.session'][:current_user]).to eq(user.id)
    end
  end

  describe "POST /sign_in (user doesn't exist)" do
    before :each do
      post "/sign_in", {:user => {name: "Sol", password: "12341234"}}
    end

    it "it redirects to the home page if user doesn't exist" do

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_request.path).to eq("/")
    end
  end

  describe "GET /user/:user_id" do
    before :each do
      post "/sign_in", {:user => {name: "Jerome", password: "12341234"}}, { 'rack.session' => {current_user: "#{user.id}"} }
    end

    it "loads the page if the user is the session's current user" do
      get "/user/#{user.id}"

      expect(last_response).to be_ok
    end

    it "prevents an unauthorized user from accessing another user's page" do
      get "/user/#{user.id}", {}, {'rack.session' => {current_user: 2} }

      expect(last_response.status).to eq(404)
    end
  end

  describe "POST /lists" do
    before :each do
      post "/lists", {:list => {id: 1, name: "New List", user_id: "#{user.id}"}}, {"rack.session" => {current_user: "#{user.id}"}}
    end

    it "should create a new list" do

      expect(List.count).to eq(1)
      expect(List.last.name).to eq("New List")
    end
  end

  describe "DELETE /list/:list_id" do
    it "deletes a list" do
      delete "list/:list_id", {id: "#{list.id}"}, {"rack.session" => {current_user: "#{user.id}"}}

      expect(List.count).to  eq(0)
    end
  end

  describe "GET /list/:list_id" do
    before :each do
      get "/list/#{list.id}", {}, {"rack.session" => {current_user: "#{user.id}"}}
    end

    it "it should load the list page" do

      expect(last_response).to be_ok
    end

    it "should show an error page to an unauthorized user" do
      get "/list/#{list.id}", {}, {"rack.session" => {current_user: 2}}

      expect(last_response.status).to eq(404)
    end
  end

  describe "POST list/:list_id/tasks" do
    it "should create a new task" do
      post "/list/#{list.id}/new/task", {:task => {name: "New Task", list_id: "#{list.id}"}}, {"rack.session" => {current_user: "#{user.id}"}}

      expect(Task.count).to eq(1)
      expect(Task.last.name).to eq("New Task")
    end
  end

  describe "DELETE /list/:list_id/task/:task_id" do
    it "should delete a task" do
      delete "/delete/list/#{list.id}/task/#{task.id}", {}, {"rack.session" => {current_user: "#{user.id}"}}

      expect(Task.count).to eq(0)
    end
  end

  describe "GET /logout" do
    it "ends a session" do
      get "/logout", {}, {"rack.session" => {current_user: "#{user.id}"}}

      expect(rack_mock_session.cookie_jar[:current_user]).to eq(nil)
    end
  end
end
