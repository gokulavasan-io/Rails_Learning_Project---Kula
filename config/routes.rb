Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create,:show]
      resources :products
      resources :orders do
        resources :order_items, only:[:create,:update,:destroy]
      end
    end
  end
end
