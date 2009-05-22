require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/iknowjoshstone')

# These lines only work outside of passenger
local_env = (ENV['RACK_ENV'] || :development).to_sym
Iknowjoshstone.set :environment, local_env

run Iknowjoshstone
