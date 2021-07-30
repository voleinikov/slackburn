module BotViews
  module Uvi
    class EntryPoint < BotViews::Base
      attr_accessor :channel_id, :errant_value

      def render
        if self.errors.any?
          {
            "blocks": [
              {
                "dispatch_action": true,
                "type": "input",
                "element": {
                  "type": "plain_text_input",
                  "action_id": "uvi_zip_input",
                  "initial_value": "#{self.errant_value}"
                },
                "label": {
                  "type": "plain_text",
                  "text": "Please enter your five digit zipcode."
                }
              },
              {
                "type": "context",
                "elements": [
                  {
                    "type": "mrkdwn",
                    "text": ":exclamation: *#{self.errors.first}* :exclamation:"
                  }
                ]
              }
            ]
          }
        else
          {
            channel: self.channel_id,
            "blocks": [
              {
                "dispatch_action": true,
                "type": "input",
                "element": {
                  "type": "plain_text_input",
                  "action_id": "uvi_zip_input"
                },
                "label": {
                  "type": "plain_text",
                  "text": "Please enter your five digit zipcode."
                }
              }
            ]
          }
        end
      end
    end
  end
end