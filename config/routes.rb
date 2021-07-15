Rails.application.routes.draw do
  namespace :test_api, constraints: { format: 'json' } do
    post 'try_it',
      controller: 'test_endpoint',
      action: 'try_it'
  end
end