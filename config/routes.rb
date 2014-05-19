Rails.application.routes.draw do
  root 'home#index'

  resources :sources do
    resource :header, only: :edit
  end
end
