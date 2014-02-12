class User < ActiveRecord::Base
  has_many :tweets
  def tweet(status, delay)
    tweet = Tweet.create!(content: status)
    self.tweets << tweet
    jid = TweetWorker.delay_for(delay.to_i.seconds).perform_async(tweet.id)
    return {tweet:tweet.content, jid:jid}
  end
end

