Rails.application.routes.draw do
  root 'users#index'
  post 'authenticate', to: 'users#authenticate'
end
