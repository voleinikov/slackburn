SlackRubyBotServer::Events.configure do |config|
  config.on :action, 'block_actions', 'suntime_submit' do |action|
    payload = action[:payload]
    action.logger.info "suntime_submit triggered"

    # Get UVI and ZipCode from the "extra state" passed via the submit button
    # since we can't pass additional_metadata in message blocks (only modals)
    extra_state = payload["actions"][0]["value"]
    uvi, zipcode = extra_state.split(" ")

    # Get the spf and skin type from the state object we get from Slack
    spf = payload["state"]["values"]["spf_select"]["spf_select"]["selected_option"]["value"]
    skin_type = payload["state"]["values"]["skin_type_select"]["skin_type_select"]["selected_option"]["value"]

    exposure_minutes = SuntimeService.get_sun_time(skin_type, uvi, spf)

    begin 
      msg = BotViews::Suntime::Submit.new({
        spf: spf,
        zipcode: zipcode,
        expo_minutes: exposure_minutes
      }).render
    rescue CustomError => ce
      action.logger.info "Error: #{ce.class}"
      action.logger.info "Internal error message: #{ce.message}"
      msg = BotViews::Suntime::Submit.new({ errors: [ce.custom_msg]}).render
    rescue => e
      action.logger.info "Error: #{e}"
      msg = BotViews::Suntime::Submit.new({ errors: [ "Sorry. An error has occurred. Please try again soon!" ] }).render
    end

    Faraday.post(
      payload[:response_url],
      msg.to_json, 
      'Content-Type' => 'application/json'
    )
  end
end