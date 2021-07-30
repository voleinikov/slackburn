module BotViews
  module Uvi
    class Action < BotViews::Base
      attr_accessor :zipcode, :uvi

      def render
        msg = if self.errors.any?
          { text: self.errors.first }
        else
          { text: "The current UVI at zipcode #{self.zipcode} is #{self.uvi}."}
        end.merge({ response_type: "ephemeral" })

        msg
      end
    end
  end
end