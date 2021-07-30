SlackRubyBotServer::Events.configure do |config|
  config.on :action, 'block_actions', 'uvi_zip_input' do |action|
    payload = action[:payload]
    action.logger.info "uvi_zip_input triggered"
    zipcode = payload["actions"][0]["value"]
    
    begin 
      uvi = UviService.get_uvi(zipcode)
      msg = BotViews::Uvi::Action.new({ zipcode: zipcode, uvi: uvi }).render
    rescue CustomError => ce
      action.logger.info "Error: #{ce.class}"
      action.logger.info "Internal error message: #{ce.message}"
      msg = BotViews::Uvi::EntryPoint.new({ errors: [ce.custom_msg], errant_value: zipcode }).render
    rescue => e
      action.logger.info "Error: #{e}"
      msg = BotViews::Uvi::Action.new({ errors: [ "Sorry. An error has occurred. We'll figure it out and be back soon!" ] }).render
    end

    Faraday.post(
      payload[:response_url],
      msg.to_json, 
      'Content-Type' => 'application/json'
    )
  end
end