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
  end

  get '/login' do
    redirect to("/auth/twitter")
  end

  get '/' do
    "<h1>Hi #{session[:username]}!</h1>"
  end

  get '/auth/twitter/callback' do
    env['omniauth.auth'] ? session[:logged_in] = true : halt(401,'Not Authorized')
    session[:username] = env['omniauth.auth']['info']['name']
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
