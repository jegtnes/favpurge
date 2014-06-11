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
      output << fav.text
    end
    return output
  end
end
