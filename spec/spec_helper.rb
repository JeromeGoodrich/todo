require 'rack/test'
require 'rspec'

require File.expand_path "../../sinatra_todo_app.rb", __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/list_test.db")
  DataMapper.finalize
  List.auto_migrate!
  Task.auto_migrate!
  User.auto_migrate!
end
