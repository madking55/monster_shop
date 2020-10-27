Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
  end

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]
  resources :orders, only: [:new, :create, :show]
  resources :users, only: [:create, :update]
  
  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'
  
  
  get '/registration', to: 'users#new', as: :registration
  
  get '/profile/edit', to: 'users#edit'
  get '/profile', to: 'users#show'
  get '/profile/orders', to: 'user_orders#index'
  get '/profile/edit_password', to: 'users#edit_password'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
end
