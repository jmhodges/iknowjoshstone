require 'rubygems'
require "test/unit"
require "nokogiri"
require "webrat/sinatra"

Webrat.configure do |config|
  config.mode = :sinatra
end

Sinatra::Base.set :environment, :test

require "iknowjoshstone"

class Test::Unit::TestCase
  include Webrat::Methods
  include Webrat::Matchers
 
  Webrat::Methods.delegate_to_session :response_code, :response_body, :response
  Webrat::SinatraSession.send(:public, :response)
end
