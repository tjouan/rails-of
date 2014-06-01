Rails.application.routes.draw do
  root 'home#index'

  resources :sources do
    resource :headers, only: :new
  end

  resources :operations, only: [:index, :show]

  resources :works, only: [:index, :new, :create]
end
