Rails.application.routes.draw do
  root 'home#index'

  resources :data_files
end
