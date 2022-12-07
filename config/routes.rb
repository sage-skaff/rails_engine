Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show]
      resources :items, only: %i[index show create update destroy]
    end
  end
end
