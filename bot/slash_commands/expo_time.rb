SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/expo_time' do |command|
    command.logger.info 'Receivied an expo_time request.'
    skin_type, zipcode, spf = command[:text].split(' ')
    begin
      uvi = UviService.get_uvi(zipcode)
      exposure_minutes = SuntimeService.get_sun_time(skin_type, uvi, spf)

      # We're re-using the same view Suntime uses on final submit, that's why
      # you're seeing hte Suntime::Submit BotView here. 
      BotViews::Suntime::Submit.new({
        spf: spf,
        zipcode: zipcode,
        expo_minutes: exposure_minutes
      }).render
    rescue CustomError => ce
      command.logger.info "Error: #{ce.class}"
      command.logger.info "Internal error message: #{ce.message}"
      BotViews::Suntime::Submit.new({ errors: [ ce.custom_msg ] }).render
    rescue => e
      command.logger.info "Error: #{e}"
      BotViews::Suntime::Submit.new({ 
        errors: [
          "Sorry. An error has occurred. We'll figure it out and be back soon!"
        ] 
      }).render
    end
  end
end