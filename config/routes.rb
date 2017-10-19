Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :products
  resources :merchants


  get '/orders', to: 'orders#index', as: 'orders'
  get '/orders/new', to: 'orders#new', as: 'new_order'
  post '/orders', to: 'orders#create'
  get '/orders/:id', to: 'orders#show', as: 'order'
  get '/orders/:id/edit', to: 'orders#edit', as: 'edit_order'
  patch '/orders/:id', to: 'orders#update'

  get '/reviews', to: 'reviews#index', as: 'reviews'
  get '/reviews/new', to: 'reviews#new', as: 'new_review'
  post '/reviews', to: 'reviews#create'
  get '/reviews/:id', to: 'review#show', as: 'review'
  get '/reviews/:id/edit', to: 'reviews#edit', as: 'edit_review'

  resources :orders
  resources :reviews
  root 'main#index'

  resources :orderitems, only: [:create, :index, :destroy, :update]


  resources :categories, only: [:new, :create]

  # nested routes
  resources :categories do
    resources :products, only: [:index]
  end

  get '/auth/:provider/callback', to: 'merchants#login', as: 'auth_callback'
  get 'logout', to: 'merchants#logout', as: 'logout'

end
