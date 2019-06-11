Rails.application.routes.draw do
  resources :artifacts, only: [:new, :destroy]

  resources :notes, controller: 'artifacts', except: [:new, :destroy, :index]
  resources :images, controller: 'artifacts', except: [:new, :destroy, :index]

  resources :sessions, only: [:create, :destroy]
  resources :users, except: [:show]
  resources :projects, except: [:show, :edit]

  root  'users#index'

  get   'notfound', to: 'errors#not_found', as: 'not_found'
  get   'notauthorized', to: 'errors#not_authorized', as: 'not_authorized'

  post  '/authenticate', to: 'sessions#create'
  get   '/logout', to: 'sessions#destroy'

  get   '/user/settings', to: 'users#settings'
  get   '/user/settings/account', to: 'users#settings_account'
  post  '/user/settings/update_password', to: 'users#update_password'
  get   '/user/:login', to: 'users#show'

  get   '/projects/:project_name', to: 'projects#show', as: 'project_show'
  post  '/projects/invite', to: 'projects#invite'
  get   '/projects/:project_name/settings', to: 'projects#edit', as: 'settings'
  get   '/traceability/:project_name', to: 'projects#traceability', as: 'traceability'

  post  '/artifacts/new', to: 'artifacts#create'
  get   '/:project_name/:type/edit/:title/', to: 'artifacts#edit'
  get   '/projects/:project_name/artifacts/new', to: 'artifacts#new', as: 'artifact_menu'
  get   '/:project_name/artifact/:title', to: 'artifacts#show'
  get   '/:project_name/versions/:title', to: 'artifacts#show_versions'
  get   '/:project_name/artifact/version/:hash', to: 'artifacts#show_version'
  get   '/projects/:name/artifacts/new/:type', to: 'artifacts#new_type'
  get   '/:project_name/:resource', to: 'artifacts#index'
end
