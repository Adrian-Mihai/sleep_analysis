Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      post 'generate_token', action: 'generate_token', controller: 'authentication'

      resources :users, only: %i[show create update] do
        resources :sleep_files, only: %i[index create destroy]

        namespace :sleep_analysis do
          resources :averages, only: :index
          resources :statistics, only: :index
        end
      end
    end
  end
end
