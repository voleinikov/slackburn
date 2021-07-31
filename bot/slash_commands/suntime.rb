SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/suntime' do |command|
    command.logger.info 'Receivied a suntime request.'
    skin_type, zipcode, spf = command[:text].split(' ')
    begin
      uvi = UviService.get_uvi(zipcode)
      exposure_minutes = SuntimeService.get_sun_time(skin_type, uvi, spf)
      hs = SuntimeService.humanize_suntime(exposure_minutes)
      h_sunscreen = SuntimeService.humanize_spf(spf)
      { text: "You can currently spend #{hs} in the sun #{h_sunscreen} at zip code: #{zipcode}" }
    rescue CustomError => ce
      command.logger.info "Error: #{ce.class}"
      command.logger.info "Internal error message: #{ce.message}"
      { text: ce.custom_msg }
    rescue => e
      command.logger.info "Error: #{e}"
      { text: "Sorry. An error has occurred. We'll figure it out and be back soon!" }
    end
  end
end