Rails.application.routes.draw do

  resources :notes, controller: 'artifacts'
  resources :sessions
  resources :users
  resources :projects
  resources :artifacts

  root 'users#index'

  post '/authenticate' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/user/settings', to: 'users#settings'
  get '/user/:login', to: 'users#show'

  get '/artifacts/new/:type', to: 'artifacts#new_type'

end
