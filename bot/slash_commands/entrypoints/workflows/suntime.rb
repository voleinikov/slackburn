SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/suntime' do |command|
    command.logger.info 'Recieved suntime command'
    cid = command[:channel_id]

    BotViews::Suntime::EntryPoint.new({channel_id: cid}).render
  end
end