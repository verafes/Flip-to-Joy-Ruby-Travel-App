Rails.application.routes.draw do
  devise_for :users, controllers: {
          registrations: 'users/registrations'
        }

  get "trips/open", to: "open_trips#index", as: :open_trips

  resources :trips
  resources :booked_trips

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
