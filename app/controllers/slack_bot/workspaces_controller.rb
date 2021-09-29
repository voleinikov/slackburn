module SlackBot
  class WorkspacesController < ApplicationController

    # Adapted from create code in Slack-Ruby-Bot-Server gem found here:
    # https://github.com/slack-ruby/slack-ruby-bot-server/blob/master/lib/slack-ruby-bot-server/api/endpoints/teams_endpoint.rb
    def create
      intermediate_token = params[:code]

      authentication_params = {
        client_id: Rails.application.credentials.slack[:client_id],
        client_secret: Rails.application.credentials.slack[:client_secret],
        code: intermediate_token
      }

      begin 
      
        # Slack's OAuth API takes a URL-encoded payload,
        # and responds with JSON
        auth_response = Faraday.post(
          'https://slack.com/api/oauth.v2.access',
          URI.encode_www_form(authentication_params), 
          'Content-Type' => 'application/x-www-form-urlencoded'
        )
        
        raise ControllerError.new("Error: Faraday response failed with code #{auth_response.status}") if auth_response.status != 200 

        parsed_response = JSON.parse(auth_response.body)
        
        raise ControllerError.new("Error: Slack responded with failure msg: #{parsed_response['error']}") unless parsed_response["ok"]

        oauth_scopes_str = SlackRubyBotServer::Config.oauth_scope_s
        oauth_version_str = SlackRubyBotServer::Config.oauth_version.to_s

        slack_team_id = parsed_response["team"]["id"]
        workspace = Workspace.where(slack_team_id: slack_team_id).first

        if workspace
          workspace.update!({
            oauth_version: oauth_version_str,
            oauth_scopes: oauth_scopes_str,
            token: parsed_response["access_token"]
          })
        else
          Workspace.create!({
            oauth_version: oauth_version_str,
            oauth_scopes: oauth_scopes_str,
            slack_team_id: slack_team_id,
            name: parsed_response["team"]["name"],
            token: parsed_response["access_token"]
          })
        end

        render json: {}, status: :ok

      rescue ControllerError => e
        render json: { error: e.message }, status: :bad_request

      rescue => e
        render json: { error: "Something went wrong! #{e.message}"}, status: :internal_server_error

      end
    end
  end
end