Rails.application.routes.draw do

  resources :sessions

  resources :users
  resources :projects

  root 'users#index'

  post '/authenticate' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  post 'authenticate', to: 'users#authenticate'
end
