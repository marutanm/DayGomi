require 'json'
require 'twitter'

class Tweet
  def initialize
    Twitter.configure do |config|
      config.consumer_key       = ENV['CONSUMER_KEY']
      config.consumer_secret    = ENV['CONSUMER_SECRET']
      config.oauth_token        = ENV['OAUTH_TOKEN']
      config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
    end
  end

  def post tweet
    Twitter.update tweet rescue nil
  end
end

handler do |job|
  day = Time.now.wday
  data = open('data.json','r'){|fp|
    JSON.parse(fp.read)
  }
  if data[day].class == String
    Tweet.new.post data[day] unless data[day] == ""
  else
    Tweet.new.post data[day][0] if data[day][1].include?(Time.now.mday.div(7) + 1)
  end
end

every(1.day, 'Today\'s gomi', :at => '07:30')
