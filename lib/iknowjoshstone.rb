require 'sinatra/base'
require 'sequel'

def here(fname)
  File.expand_path(File.dirname(__FILE__) + '/' + fname)
end

class Iknowjoshstone < Sinatra::Base
  VERSION = '1.0.0'
  set :app_file, __FILE__
  configure do
    dbfile = here("../db/#{environment}.sqlite3")
    DB = Sequel.sqlite(dbfile)
    unless DB.table_exists?(:posts)
      DB.create_table(:posts) do
        String :whotheyare
        String :howtheyknowhim
        DateTime :created_at
      end
    end
  end
  get '/' do
    @saved_for = params["saved_for"]
    @posts = DB[:posts].order(:created_at).limit(10)
    haml :index
  end

  get '/posts/new' do
    haml :new
  end

  post '/posts/create' do
    new_post = params["post"].merge(:created_at => Time.now)
    DB[:posts] << new_post
    redirect "/?saved_for=#{new_post['whotheyare']}"
  end
end
