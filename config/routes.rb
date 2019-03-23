Rails.application.routes.draw do
  resources :artifacts, only: [:new, :destroy]

  resources :notes, controller: 'artifacts', except: [:new, :destroy, :index]
  resources :images, controller: 'artifacts', except: [:new, :destroy, :index]

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

  post  '/artifacts/new', to: 'artifacts#create'
  get   '/:type/edit/:id/', to: 'artifacts#edit'
  get   '/:project_id/:resource', to: 'artifacts#index'
  get   '/projects/:id/artifacts/new', to: 'artifacts#new'
  get   '/:project_id/artifact/:title', to: 'artifacts#show'
  get   '/:project_id/versions/:title', to: 'artifacts#show_versions'
  get   '/projects/:id/artifacts/new/:type', to: 'artifacts#new_type'
end
