SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/sun_time' do |command|
    command.logger.info 'Recieved sun_time command'
    cid = command[:channel_id]

    BotViews::SunTime::EntryPoint.new({channel_id: cid}).render
  end
end