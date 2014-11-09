require 'bundler/setup'
require 'sinatra'
require 'sinatra/jsonp'
require 'rubygems'
require 'dotenv'
require 'twitter'
require 'omniauth-twitter'

Dotenv.load

# Fetch tweets, yo.
class TwitterFetcher < Sinatra::Base
  helpers Sinatra::Jsonp

  configure do
    enable :sessions
    require 'pp'

    use OmniAuth::Builder do
      provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
    end
  end

  helpers do
    def logged_in?
      session[:logged_in]
    end

    def client
      if logged_in?
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['CONSUMER_KEY']
          config.consumer_secret     = ENV['CONSUMER_SECRET']
          config.access_token        = session[:oauth_token]
          config.access_token_secret = session[:oauth_secret]
        end
      else
        false
      end
    end
  end

  get '/login' do
    redirect to("/auth/twitter")
  end

  get '/' do
    if logged_in?
      erb :index, :layout => :layout
    else
      erb '<a href="/login">Log in</a>', :layout => :layout
    end
  end

  get '/auth/twitter/callback' do
    env['omniauth.auth'] ? session[:logged_in] = true : halt(401,'Not Authorized')
    session[:username] = env['omniauth.auth']['info']['name']
    session[:oauth_token] = env['omniauth.auth']['credentials']['token']
    session[:oauth_secret] = env['omniauth.auth']['credentials']['secret']
    redirect to '/'
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/logout' do
    session[:logged_in] = nil
    "You are now logged out"
  end
end
