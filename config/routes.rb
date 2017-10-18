Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

<<<<<<< HEAD

  resources :products

  
  get '/orders', to: 'orders#index', as: 'orders'
  get '/orders/new', to: 'orders#new', as: 'new_order'
  post '/orders', to: 'orders#create'
  get '/orders/:id', to: 'orders#show', as: 'order'
  get '/orders/:id/edit', to: 'orders#edit', as: 'edit_order'
  patch '/orders/:id', to: 'orders#update'

  resources :orders
=======
root 'main#index'

get '/orders', to: 'orders#index', as: 'orders'
get '/orders/new', to: 'orders#new', as: 'new_order'
post '/orders', to: 'orders#create'
get '/orders/:id', to: 'orders#show', as: 'order'
get '/orders/:id/edit', to: 'orders#edit', as: 'edit_order'
patch '/orders/:id', to: 'orders#update'

resources :orders

>>>>>>> fe453036270767475c550414e821db164ea62538
end
