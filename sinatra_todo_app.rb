require 'sinatra'
require 'data_mapper'

get '/' do
  @lists = List.all
  erb :index
end

post '/' do
  List.create(params[:list])
  redirect to ('/')
end

get '/:id' do
  @list = List.get(params[:id])
  @tasks = Task.all(:list_id => params[:id])
  erb :list
end

post '/:id' do
  Task.create(params[:task])
  redirect to ("/#{params[:id]}")
end

delete '/:id' do
  List.get(params[:id]).destroy
  redirect to ("/")
end

delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect to ("/#{params[:list_id]}")
end

put '/task/:id' do
  task = Task.get(params[:id])
  if task.done == false
    task.done = true
  else
    task.done = false
  end
    task.save
  redirect to ("/#{params[:list_id]}")
end


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/lists/lists.db")

class List
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required => true

  has n, :tasks
end

class Task
  include DataMapper::Resource
  property :id,      Serial
  property :list_id, Integer
  property :name,    String,  :required => true
  property :done,    Boolean, :default => false

  belongs_to :list
end

DataMapper.finalize


