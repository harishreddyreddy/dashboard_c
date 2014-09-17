require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter.configure do |config|
  config.consumer_key = ''
  config.consumer_secret = ''
end

search_term = URI::encode('#coupa')

SCHEDULER.every '960s', :first_in => 0 do |job|
  begin
    tweets = Twitter.search("#{search_term}").results

    if tweets
      tweets = tweets.map! do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
