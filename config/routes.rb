Rails.application.routes.draw do
  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :movies, only: %i(index create)

      resources :schedules, only: [] do
        member do
          resources :bookings, only: %i(create)
        end

        collection do
          resources :bookings, only: %i(index)
        end
      end
    end
  end
end
