Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[show create update] do
        resources :sleep_files, only: %i[index create destroy]

        namespace :sleep_analysis do
          resources :averages, only: :index
        end
      end
    end
  end
end
