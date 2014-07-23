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

  use OmniAuth::Builder do
    provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end

  configure do
    enable :sessions
  end

  twitter_client = Twitter::REST::Client.new(
    consumer_key:       ENV['CONSUMER_KEY'],
    consumer_secret:    ENV['CONSUMER_SECRET'],
    oauth_token:        ENV['OAUTH_TOKEN'],
    oauth_token_secret: ENV['OAUTH_SECRET']
  )

  get '/' do
    output = ''
    favs = twitter_client.favorites('jegtnes', count: 100)
    favs.each do |fav|
      output << '<p>' + fav.text + '</p>'
    end
    return output
  end

  get '/login' do
    redirect to '/auth/twitter'
  end

  get '/env' do
    ENV['RACK_ENV']
  end

  get '/auth/twitter/callback' do
    session[:admin] = true
    env['omniauth.auth']
  end
end
