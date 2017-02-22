class Twimane
  require 'twitter'

  def tweet(text , settei)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = settei['key']
      config.consumer_secret      = settei['secret']
      config.access_token         = settei['token']
      config.access_token_secret  = settei['token_secret']
    end
  client.update(text)
  return settei["baseUrl"] + "/management/update"
  end

  def get_tweet(settei)
    tags = settei["tags"]
    @@regexp = Regexp.union(tags)
    @@user = settei["twitterName"]

    ret = []
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = settei['key'] 
      config.consumer_secret      = settei['secret'] 
      config.access_token         = settei['token'] 
      config.access_token_secret  = settei['token_secret'] 
    end

    max_id = client.home_timeline.first.id
    1.times do

      client.user_timeline(@@user,max_id: max_id,count: 200).each do |tweet|
        if (tweet.text.match( @@regexp))
          url = tweet.urls[0].expanded_url
          text = tweet.text
          text = text.gsub(/\n/,"")
          text = text.gsub(/https.*$/,"")
          time = tweet.created_at
          uri = tweet.uri
          ret.push([uri.to_s,url.to_s,time,text])
        end
        max_id = tweet.id unless tweet.retweeted?
      end
#      sleep 10
    end
    return ret
  end
end

