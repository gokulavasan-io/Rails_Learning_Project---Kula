require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    namespace :v1 do

      resource :cart
      post 'login', to: 'auth#login'
      resources :orders
      resources :order_items, only:[:update,:destroy]
      resources :products
      resources :users, only: [:index, :create,:show]

    end
  end
end
