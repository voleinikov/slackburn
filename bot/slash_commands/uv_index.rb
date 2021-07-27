SlackRubyBotServer::Events.configure do |config|
  config.on :command, '/uv_index' do |command|
    command.logger.info 'Receivied a uv_index request.'
    zipcode = command[:text]
    begin
      uvi = UviService.get_uvi(zipcode)
      { text: "Current UVI at zipcode #{zipcode}: #{uvi}" }
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