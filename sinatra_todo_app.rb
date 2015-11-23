require 'sinatra'
require 'sinatra/flash'
require 'data_mapper'
require 'bcrypt'

enable :sessions

get '/' do
  erb :home
end

post '/sign_up' do
  user = User.create(params[:user])
  session[:current_user] = user.id
  redirect to ("/user/#{user.id}")
end

post '/sign_in' do
  user = User.first(:name => params[:user][:name])
  if user == nil
    flash[:no_user] = "no user was found by that name"
    erb :home
  elsif user.password != params[:user][:password]
    flash[:password_error] = "incorrect password"
    erb :home
  else
    session[:current_user] = user.id
    redirect to ("/user/#{user.id}")
  end
end

get '/user/:id' do
  @user = User.get(params[:id])
  if session[:current_user] == @user.id
    @lists = List.all(:user_id => params[:id])
    erb :index
  else
    flash[:unauthorized] = "tsk tsk that page isn't yours"
    redirect to ("/user/#{session[:current_user]}")
  end
end

post '/new/list' do
  List.create(params[:list])
  redirect to ("/user/#{session[:current_user]}")
end

delete '/delete/list' do
  List.get(params[:id]).destroy
  redirect to ("/user/#{session[:current_user]}")
end

get '/list/:list_id' do
  @list = List.get(params[:list_id])
  if authorize?(@list)
    @tasks = Task.all(:list_id => @list.id)
    erb :list
  end
end

post '/list/:list_id/new/task' do
  @list = List.get(params[:list_id])
  if authorize?(@list)
    Task.create(params[:task])
    redirect to ("/list/#{@list.id}")
  end
end

put '/list/:list_id/task/:task_id' do
  @list = List.get(params[:list_id])
  if authorize?(@list)
    task = Task.get(params[:task_id])
    task.done = !task.done
    task.save
    redirect to ("list/#{@list.id}")
  end
end

delete '/delete/list/:list_id/task/:task_id' do
  @list = List.get(params[:list_id])
  if authorize?(@list)
    task = Task.get(params[:task_id])
    task.destroy
    redirect to ("/list/#{task.list_id}")
  end
end

get '/logout' do
  session.clear
  redirect to ("/")
end

not_found do
  erb :oops
end

def authorize?(list)
  lists = List.all(user_id: session[:current_user])
  if lists.include?(list)
    true
  else
    flash[:unauthorized] = "tsk tsk that list isn't yours"
    redirect to ("/user/#{session[:current_user]}")
  end
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/lists/lists.db")

class List
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true
  property :user_id, Integer, :required => true

  has n, :tasks
  belongs_to :user
end

class Task
  include DataMapper::Resource
  property :id,      Serial
  property :list_id, Integer
  property :name,    String,  :required => true
  property :done,    Boolean, :default => false

  belongs_to :list
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :password, BCryptHash, :required => true

  has n, :lists
end

DataMapper.finalize
DataMapper.auto_upgrade!

