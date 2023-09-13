require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'], scope: 'user-read-private user-read-email user-read-playback-state user-modify-playback-state streaming user-top-read' 
end

OmniAuth.config.allowed_request_methods = [:post, :get]