module BotViews
  module Suntime
    class Submit < BotViews::Base
      attr_accessor :spf, :zipcode, :expo_minutes

      def humanized_suntime
        from_time = Time.now
  
        ApplicationController
          .helpers
          .distance_of_time_in_words(from_time, from_time + self.expo_minutes.minutes)
      end
  
      def humanized_spf
        spf = [self.spf.to_i, 1].max
  
        if spf == 1 
          return "without sunscreen"
        else
          "wearing SPF #{spf} sunscreen"
        end
      end

      def render
        msg = if self.errors.any?
          { text: self.errors.first }
        else
          { text: "You can currently spend #{humanized_suntime} in the sun #{humanized_spf} at zip code: #{self.zipcode}" }
        end.merge({ response_type: "ephemeral" })

        msg
      end
    end
  end
end