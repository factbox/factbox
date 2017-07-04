Rails.application.routes.draw do

  resources :sessions
  # we use user model like uruta_user
  resources :uruta_users, controller: 'users'
  resources :projects

  root 'users#index'

  post '/authenticate' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  post 'authenticate', to: 'users#authenticate'
end
