Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html





  get '/orders', to: 'orders#index', as: 'orders'
  get '/orders/new', to: 'orders#new', as: 'new_order'
  post '/orders', to: 'orders#create'
  get '/orders/:id', to: 'orders#show', as: 'order'
  get '/orders/:id/edit', to: 'orders#edit', as: 'edit_order'
  patch '/orders/:id', to: 'orders#update'

  get '/order_items', to: 'order_items#index', as: 'order_items'

  get '/merchants/:id', to: 'merchants#show', as: 'merchant'

  get '/products', to: 'products#index', as: 'products'
  get '/products/new', to: 'products#new', as: 'new_product'
  post '/products', to: 'products#create'
  get '/products/:id', to: 'products#show', as: 'product'
  patch '/products/:id', to: 'products#update'

  resources :orders, :products, :merchants
  root 'main#index'

  resources :orderitems, only: [:create, :index, :destroy, :update]

end
