require 'sinatra/base'
require 'sequel'
require 'Haml'

def here(fname)
  File.expand_path(File.dirname(__FILE__) + '/' + fname)
end

class Iknowjoshstone < Sinatra::Base
  VERSION = '1.0.0'
  set :app_file, __FILE__
  enable :sessions

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
    @saved_for = flash[:saved_for]
    @posts = DB[:posts].order(:created_at.desc).limit(10)
    flash_haml :index
  end

  get '/posts/new' do
    haml :new
  end

  post '/posts/create' do
    new_post = params["post"].merge(:created_at => Time.now)
    DB[:posts] << new_post
    flash[:saved_for] = new_post['whotheyare']
    redirect '/'
  end

  def flash
    session[:flash] = {} if session[:flash] && session[:flash].class != Hash
    session[:flash] ||= {}
  end

  def flash_haml(*args)
    flashed_haml = haml(*args)
    flash.clear
    flashed_haml
  end
end
