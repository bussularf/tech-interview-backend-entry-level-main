require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  resource :cart do
    post :add_item, to: 'carts#add_item'
    patch :update_quantity, to: 'carts#update_quantity'
    delete '/:product_id', to: 'carts#remove_product', as: :remove_product
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
