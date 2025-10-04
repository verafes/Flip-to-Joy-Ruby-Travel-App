Rails.application.routes.draw do
  devise_for :users, controllers: {
          registrations: 'users/registrations'
        }

  get "trips/open", to: "open_trips#index", as: :open_trips
  get "trips/my_trips", to: "trips#my_trips", as: :my_trips

  resources :trips do
    collection { get :my_trips }
    resources :booked_trips, only: [:create], controller: 'trips/booked_trips'
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
