# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

# Require Slack Bot Actions

require_relative 'bot/slash_commands'
# require_relative 'bot/events'
# require_relative 'bot/actions'

run Rails.application
Rails.application.load_server
