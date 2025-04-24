require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create,:show]
      resources :products
      resources :orders do
        resources :order_items, only:[:create,:update,:destroy]
      end
      get 'cart', to: 'carts#show'
      post 'cart/add', to: 'carts#add_item'
      delete 'cart/remove', to: 'carts#remove_item'

      post 'login', to: 'auth#login'

    end
  end
end
