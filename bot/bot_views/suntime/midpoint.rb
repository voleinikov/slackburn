module BotViews
  module Suntime
    class Midpoint < BotViews::Base
      attr_accessor :uvi, :zipcode

      def fitzpatrick_scale_options_map
        opts = (1..6).map do |n|
          {
            "text": {
              "type": "plain_text",
              "text": "Type #{n}",
            },
            "value": "#{n}"
          }
        end

        opts
      end

      def spf_options_map
        opts = [5, 15, 30, 45, 50, 80].map do |spf|
          {
            "text": {
              "type": "plain_text",
              "text": "Yes - SPF #{spf}",
            },
            "value": "#{spf}"
          }
        end.unshift(
          {
            "text": {
              "type": "plain_text",
              "text": "No",
            },
            "value": "1"
          }
        )

        opts
      end

      def main_form
        {
          "blocks": [
            {
              "type": "section",
              "block_id": "spf_select",
              "text": {
                "type": "mrkdwn",
                "text": "Are you wearing sunscreen?"
              },
              "accessory": {
                "type": "static_select",
                "placeholder": {
                  "type": "plain_text",
                  "text": "Select an item"
                },
                "action_id": "spf_select"
              }.merge({"options": spf_options_map})
            },
            {
              "type": "section",
              "block_id": "skin_type_select",
              "text": {
                "type": "mrkdwn",
                "text": "What is your skin type?"
              },
              "accessory": {
                "type": "static_select",
                "placeholder": {
                  "type": "plain_text",
                  "text": "Select an item",
                },
                "action_id": "skin_type_select"
              }.merge({"options": fitzpatrick_scale_options_map})
            },
            {
              "type": "context",
              "elements": [
                {
                  "type": "plain_text",
                  "text": "Skin type definitions below....",
                }
              ]
            },
            {
              "type": "image",
              "image_url": "http://63584a8bcc36.ngrok.io/fitzpatrick_scale.jpg",
              "alt_text": "Fitzpatrick Scale"
            },
            {
              "type": "actions",
              "elements": [
                {
                  "type": "button",
                  "text": {
                    "type": "plain_text",
                    "text": "Submit",
                  },
                  "value": "#{self.uvi} #{self.zipcode}",
                  "action_id": "suntime_submit"
                }
              ]
            }
          ]
        }
      end

      def render
        msg = if self.errors.any?
          { text: self.errors.first }
        else
          main_form
        end.merge({ response_type: "ephemeral" })

        msg
      end
    end
  end
end