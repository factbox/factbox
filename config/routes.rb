Rails.application.routes.draw do

  resources :uruta_users, controller: 'users'

  get 'projects/index'
  root 'users#index'
  post 'authenticate', to: 'users#authenticate'
end
