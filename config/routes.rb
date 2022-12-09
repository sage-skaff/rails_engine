Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, controller: 'merchant_items', only: [:index]
      end
      resources :items, only: %i[index show create update destroy]
      get '/items/:item_id/merchant', to: 'merchants#show'
    end
  end
end
