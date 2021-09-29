module SlackBot
  class StaticPagesController < ApplicationController
    def add_to_slack
      html = File.open("#{Rails.root}/bot/add_to_slack.html.erb").read
      template = ERB.new(html)

      render html: template.result.html_safe
    end
  end
end
