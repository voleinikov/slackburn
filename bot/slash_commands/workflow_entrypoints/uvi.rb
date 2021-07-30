SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/uvi' do |command|
    command.logger.info 'Recieved uvi command'
    cid = command[:channel_id]

    BotViews::Uvi::EntryPoint.new({channel_id: cid}).render
  end
end