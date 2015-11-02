#!/usr/bin/env ruby
$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require "todo_list"
require "cli"


cli = CommandLineInterface.new(ARGV)
todo = TodoList.new

cli.run
