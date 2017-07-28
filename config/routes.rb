Rails.application.routes.draw do

  resources :notes, controller: 'artifacts'
  resources :sessions, only: [:create, :destroy]
  resources :users
  resources :projects
  resources :artifacts

  root  'users#index'

  post  '/authenticate' => 'sessions#create'
  get   '/logout' => 'sessions#destroy'

  get   '/user/settings', to: 'users#settings'
  get   '/user/:login', to: 'users#show'

  get   '/projects/:id', to: 'projects#show'

  get   '/projects/:id/artifacts/new', to: 'artifacts#new'
  get   '/projects/:id/artifacts/new/:type', to: 'artifacts#new_type'
  post  '/artifacts/new', to: 'artifacts#create'

end
