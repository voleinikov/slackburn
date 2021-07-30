SlackRubyBotServer::Events.configure do |config|
  config.on :action, 'block_actions', 'sun_time_submit' do |action|
    payload = action[:payload]
    action.logger.info "sun_time_submit triggered"

    uvi = payload["actions"][0]["value"]
    spf = payload["state"]["values"]["spf_select"]["spf_select"]["selected_option"]["value"]
    skin_type = payload["state"]["values"]["skin_type_select"]["skin_type_select"]["selected_option"]["value"]

    begin 
      msg = BotViews::SunTime::Submit.new({ uvi: uvi, spf: spf, skin_type: skin_type }).render
    rescue CustomError => ce
      action.logger.info "Error: #{ce.class}"
      action.logger.info "Internal error message: #{ce.message}"
      msg = BotViews::SunTime::Submit.new({ errors: [ce.custom_msg]}).render
    rescue => e
      action.logger.info "Error: #{e}"
      msg = BotViews::SunTime::Submit.new({ errors: [ "Sorry. An error has occurred. Please try again soon!" ] }).render
    end

    Faraday.post(
      payload[:response_url],
      msg.to_json, 
      'Content-Type' => 'application/json'
    )
  end
end