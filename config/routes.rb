require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create,:show]
      resources :products
      resources :orders do
        resources :order_items, only:[:update,:destroy]
      end
      resource :cart

      post 'login', to: 'auth#login'

    end
  end
end
