Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  post 'api/authenticate', to: 'api/authentication#authenticate'
  namespace :api do
    resources :tiny_urls, only: [:create]
  end

  # Route for accessing short URLs
  get '/:short_url', to: 'api/tiny_urls#show'
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
