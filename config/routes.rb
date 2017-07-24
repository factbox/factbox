Rails.application.routes.draw do

  resources :sessions
  resources :users
  resources :projects
  resources :artifacts

  root 'users#index'

  post '/authenticate' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/user/settings', to: 'users#settings'
  get '/user/:login', to: 'users#show'

end
