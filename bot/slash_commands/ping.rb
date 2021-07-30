SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/ping' do |command|
    command.logger.info 'Receivied a ping, responding with pong.'
    { text: "Pong" }
  end
end