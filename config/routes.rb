Rails.application.routes.draw do
  devise_for :users, controllers: {
          registrations: 'users/registrations',
        }

  get "trips/open", to: "open_trips#index", as: :open_trips
  get "trips/my_trips", to: "trips#my_trips", as: :my_trips

  resources :trips do
    collection { get :my_trips }
    resources :booked_trips, only: [:create, :destroy], controller: 'trips/booked_trips'
  end
  resources :payments, only: [:new, :create]
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :trips, except: [:new, :edit] do
        collection do
          get :my_trips
        end
      end
    end
  end  

  # Defines the root path route ("/")
  root "home#index"
end
