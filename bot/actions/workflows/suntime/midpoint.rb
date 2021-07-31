SlackRubyBotServer::Events.configure do |config|
  config.on :action, 'block_actions', 'suntime_zip_input' do |action|
    payload = action[:payload]
    action.logger.info "suntime_zip_input triggered"
    zipcode = payload["actions"][0]["value"]

    begin 
      uvi = UviService.get_uvi(zipcode)
      msg = BotViews::Suntime::Midpoint.new({ uvi: uvi, zipcode: zipcode }).render
    rescue CustomError => ce
      action.logger.info "Error: #{ce.class}"
      action.logger.info "Internal error message: #{ce.message}"
      msg = BotViews::Suntime::EntryPoint.new({ errors: [ce.custom_msg], errant_value: zipcode }).render
    rescue => e
      action.logger.info "Error: #{e}"
      msg = BotViews::Suntime::Midpoint.new({ errors: [ "Sorry. An error has occurred. Please try again soon!" ] }).render
    end

    resp = Faraday.post(
      payload[:response_url],
      msg.to_json, 
      'Content-Type' => 'application/json'
    )
  end
end