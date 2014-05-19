Rails.application.routes.draw do
  root 'home#index'

  resources :data_files do
    resource :header, only: :edit
  end
end
