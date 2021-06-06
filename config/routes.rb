Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[show create update] do
        resources :sleep_files, only: %i[index create destroy]
      end
    end
  end
end
