SlackRubyBotServer.configure do |config|
  slack_oath_scopes = [
    'users:read',
    'channels:read',
    'groups:read',
    'chat:write',
    'commands',
    'incoming-webhook'
  ]
  
  config.oauth_version = :v2
  config.oauth_scope = slack_oath_scopes
end