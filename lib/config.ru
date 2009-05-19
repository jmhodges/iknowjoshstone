require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/iknowjoshstone')

local_env = (ENV['RACK_ENV'] || :development).to_sym
Iknowjoshstone.set :environment, local_env

run Iknowjoshstone
