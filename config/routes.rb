Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  devise_for :users
  resources :customers, only: [:new, :create, :index]
  resources :store, only: [:new, :create, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end