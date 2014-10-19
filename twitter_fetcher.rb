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

  def signed_in
    !session[:uid].nil?
  end

  twitter_client = Twitter::REST::Client.new(
    consumer_key:       ENV['CONSUMER_KEY'],
    consumer_secret:    ENV['CONSUMER_SECRET'],
    oauth_token:        ENV['OAUTH_TOKEN'],
    oauth_token_secret: ENV['OAUTH_SECRET']
  )

  before do
    # we do not want to redirect to twitter when the path info starts
    # with /auth/
    pass if request.path_info =~ /^\/auth\//

    # /auth/twitter is captured by omniauth:
    # when the path info matches /auth/twitter, omniauth will redirect to twitter
    redirect to('/auth/twitter') unless signed_in
  end

  get '/' do

    output = "<a href='/login'>Sign in with Twitter</a>"
    favs = twitter_client.favorites('jegtnes', count: 100)
    favs.each do |fav|
      output << '<p>' + fav.text + '</p>'
    end

    output
  end

  get '/login' do
    redirect to '/auth/twitter'
  end

  get '/env' do
    env.inspect
  end

  get '/session' do
    session[:auth].inspect
  end

  get '/auth/twitter/callback' do
    session[:uid] = env['omniauth.auth']['uid']
    # this is the main endpoint to your application
    redirect to('/')
  end
end
