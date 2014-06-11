require 'bundler/setup'
require 'sinatra'
require 'sinatra/jsonp'
require 'rubygems'
require 'dotenv'
require 'twitter'

Dotenv.load

# Fetch tweets, yo.
class TwitterFetcher < Sinatra::Base
  helpers Sinatra::Jsonp

  @@twitter_client = Twitter::Client.new(
    consumer_key:       ENV['CONSUMER_KEY'],
    consumer_secret:    ENV['CONSUMER_SECRET'],
    oauth_token:        ENV['OAUTH_TOKEN'],
    oauth_token_secret: ENV['OAUTH_SECRET']
  )

  get '/' do
    @@twitter_client.favorites('jegtnes', count: 100)
  end
end
