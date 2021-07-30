module BotViews
  module SunTime
    class Submit < BotViews::Base
      attr_accessor :uvi, :spf, :skin_type

      def render
        msg = if self.errors.any?
          { text: self.errors.first }
        else
          {text: "Thanks for your inputs: UVI:#{self.uvi} | SPF:#{self.spf} | Skin Type:#{self.skin_type}"}
        end.merge({ response_type: "ephemeral" })

        msg
      end
    end
  end
end