Rails.application.routes.draw do
  resources :artifacts, only: [:new, :destroy]

  resources :notes, controller: 'artifacts', except: [:new, :destroy, :index]
  resources :images, controller: 'artifacts', except: [:new, :destroy, :index]

  resources :sessions, only: [:create, :destroy]
  resources :users, except: [:show]
  resources :projects, except: [:show, :edit]

  root  'users#index'

  post  '/authenticate' => 'sessions#create'
  get   '/logout' => 'sessions#destroy'

  get   '/user/settings', to: 'users#settings'
  get   '/user/settings/account', to: 'users#settings_account'
  post  '/user/settings/update_password', to: 'users#update_password'
  get   '/user/:login', to: 'users#show'

  get   '/projects/:name', to: 'projects#show', as: 'project_show'
  post  '/projects/invite', to: 'projects#invite'
  get   '/projects/:name/settings', to: 'projects#edit'
  get   '/traceability/:name', to: 'projects#traceability'

  post  '/artifacts/new', to: 'artifacts#create'
  get   '/:project_name/:type/edit/:title/', to: 'artifacts#edit'
  get   '/:project_id/:resource', to: 'artifacts#index'
  get   '/projects/:name/artifacts/new', to: 'artifacts#new'
  get   '/:project_name/artifact/:title', to: 'artifacts#show'
  get   '/:project_name/versions/:title', to: 'artifacts#show_versions'
  get   '/:project_name/artifact/version/:hash', to: 'artifacts#show_version'
  get   '/projects/:name/artifacts/new/:type', to: 'artifacts#new_type'
end
