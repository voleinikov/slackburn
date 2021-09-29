Rails.application.routes.draw do
  namespace :test_api, constraints: { format: 'json' } do
    post 'try_it',
      controller: 'test_endpoint',
      action: 'try_it'
  end

  mount SlackBot::Api => '/'

  scope module: 'slack_bot' do
    get '/install_bot' => 'static_pages#add_to_slack'
    resources :workspaces, only: [:create]
  end
end