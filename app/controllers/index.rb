get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

post '/nag' do
   content_type :json
  {status:job_is_complete(params[:jid])}.to_json
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  # at this point in the code is where you'll need to create your user account and store the access token
  user = User.find_or_create_by(username: @access_token.params[:screen_name])
  user.oauth_token = @access_token.token
  user.oauth_secret = @access_token.secret
  user.save
  session[:user_id] = user.id
  erb :index
end

post '/tweet' do
  ## reset connection with the user's tokens
  tweeting_user = User.find(session[:user_id])

  tweet_info = tweeting_user.tweet(params[:tweet], params[:delay])
  content_type :json
  tweet_info.to_json
end
