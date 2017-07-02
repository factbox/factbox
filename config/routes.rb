Rails.application.routes.draw do

  resources :sessions
  # we use user model like uruta_user
  resources :uruta_users, controller: 'users'

  post 'authenticate' => 'sessions#new'
  get '/logout' => 'sessions#destroy'

  get 'projects/index'
  root 'users#index'
  post 'authenticate', to: 'users#authenticate'
end
