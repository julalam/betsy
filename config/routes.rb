Rails.application.routes.draw do
    get '/orders', to: 'orders#index', as: 'orders'
    get '/orders/new', to: 'orders#new', as: 'new_order'
    post '/orders', to: 'orders#create'
    patch '/orders/:id', to: 'orders#update'

    resources :orders
end
