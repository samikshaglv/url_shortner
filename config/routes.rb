Rails.application.routes.draw do
  namespace :api do
    resources :tiny_urls, only: [:create]
  end

  # Route for accessing short URLs
  get '/:short_token', to: 'api/tiny_urls#show', as: :short_url
  
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
