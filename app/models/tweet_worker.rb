class TweetWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  sidekiq_retry_in do |count|
    10 * (count + 1)
  end

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user  = tweet.user
    client = create_client(user)
    client.update(tweet.content)
  end

  def create_client(user)
    env_config = YAML.load_file(APP_ROOT.join('config', 'twitter.yaml'))
    env_config.each do |key, value|
      ENV[key] = value
    end
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
      config.access_token = user.oauth_token
      config.access_token_secret = user.oauth_secret
    end
    return client
  end

end
