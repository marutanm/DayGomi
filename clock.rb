require 'json'
require 'twitter'

def post tweet
  Twitter.configure do |config|
    config.consumer_key       = ENV['CONSUMER_KEY']
    config.consumer_secret    = ENV['CONSUMER_SECRET']
    config.oauth_token        = ENV['OAUTH_TOKEN']
    config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
  end
  print "#{Time.now}: #{tweet}"
  Twitter.update tweet rescue nil
end

#1..7 => 1, 8..14 => 2, 15..21 => 3, 22..28 => 4, 29..31 => 5
def week_of_month
  wmonth = Time.now.mday.divmod 7
  return wmonth[0] + 1 unless wmonth[1] == 0
  wmonth[0]
end

every(1.day, 'Today\'s gomi', :at => '07:30') do
  day = Time.now.wday
  data = open('data.json','r'){|fp| JSON.parse(fp.read)}
  if data[day].class == String
    message = data[day]
  else
    message = data[day][0] if data[day][1].include?(week_of_month)
  end
  post message unless data[day] == ""
end
