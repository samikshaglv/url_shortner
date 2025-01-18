Rails.application.routes.draw do
  namespace :api do
    resources :tiny_urls, only: [:create]
  end
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
