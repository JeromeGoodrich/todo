require 'sinatra'
require 'data_mapper'

get '/' do
  erb :sign_up
end

post '/' do
  @current_user = User.create(params[:user])
  redirect to ("/user/#{@current_user.id}")
end

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do

end

get '/user/:id' do
  @current_user = User.get(params[:id])
  @lists = List.all(:user_id => params[:id])
  erb :index
end

post '/user/:id' do
  @current_user = User.get(params[:id])
  List.create(params[:list])
  redirect to ("/user/#{@current_user.id}")
end

delete '/user/:id' do
  @current_user = User.get(params[:id])
  List.get(params[:id]).destroy
  redirect to ("/user/#{@current_user.id}")
end

get '/user/*/list/*' do
  # require 'pry'; binding.pry
  @current_user = User.get(params[:splat][0])
  @list = List.get(params[:splat][1])
  @tasks = Task.all(:list_id => @list.id)
  erb :list
end

post '/user/*/list/*' do
  @current_user = User.get(params[:splat][0])
  @list = List.get(params[:splat][1])
  Task.create(params[:task])
  redirect to ("/user/#{@current_user.id}/list/#{@list.id}")
end

put '/user/*/list/*/task/*' do
  @current_user = User.get(params[:splat][0])
  @list = List.get(params[:splat][1])
    task = Task.get(params[:splat][2])
    if task.done == false
      task.done = true
    else
      task.done = false
    end
      task.save
    redirect to ("/user/#{@current_user.id}/list/#{@list.id}")
end

delete '/user/*/list/*/task/*' do
  @current_user = User.get(params[:splat][0])
  @list = List.get(params[:splat][1])
  Task.get(params[:splat][2]).destroy
  redirect to ("/user/#{@current_user.id}/list/#{@list.id}")
end

not_found do
  status 404
  status 500
  erb :oops
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

  has n, :lists
end

DataMapper.finalize
DataMapper.auto_upgrade!

