Rails.application.routes.draw do

  resources :artifacts, only: [:new]
  resources :notes, controller: 'artifacts'
  resources :images, controller: 'artifacts'
  resources :sessions, only: [:create, :destroy]
  resources :users
  resources :projects

  root  'users#index'

  post  '/authenticate' => 'sessions#create'
  get   '/logout' => 'sessions#destroy'

  get   '/user/settings', to: 'users#settings'
  get   '/user/:login', to: 'users#show'

  get   '/projects/:id', to: 'projects#show'

  get   '/traceability/:id', to: 'projects#traceability'

  get   '/:project_id/artifact/:title', to: 'artifacts#show'

  get   '/projects/:id/artifacts/new', to: 'artifacts#new'
  get   '/projects/:id/artifacts/new/:type', to: 'artifacts#new_type'

  get   '/:type/edit/:id/', to: 'artifacts#edit'

  post  '/artifacts/new', to: 'artifacts#create'

end
