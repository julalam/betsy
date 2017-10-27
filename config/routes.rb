Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'merchants/:merchant_id/orders/status/:status_id', to: 'orders#index', as: 'merchant_orders'

  resources :products
  resources :merchants

  resources :orders, except: [:show]
  resources :reviews, except: [:new]
  root 'main#index'

  resources :order_items, only: [:create, :index, :destroy, :update]

  resources :categories, only: [:create, :index]

  # nested routes
  resources :categories do
    resources :products, only: [:index]
  end

  resources :merchants do
    resources :products, only: [:index]
  end

  resources :merchants do
    resources :categories, only: [:index, :new]
  end

  resources :merchants do
    resources :categories, only: [:show] do
      resources :products, only: [:index]
    end
  end

  get '/products/:id/reviews/new', to: 'reviews#new', as: 'new_product_review'

  resources :merchants do
    resources :orders, only: [:show]
  end

  get '/products/merchant/:id', to: 'products#index_by_merchant', as: 'products_merchant'

  get '/products/category/:id', to: 'products#index_by_category', as: 'products_category'

  get '/auth/:provider/callback', to: 'merchants#login', as: 'auth_callback'

  get 'logout', to: 'merchants#logout', as: 'logout'

  get '*path' => redirect('/404')

end
