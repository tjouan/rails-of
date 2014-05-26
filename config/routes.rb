Rails.application.routes.draw do
  root 'home#index'

  resources :sources do
    resource :headers, only: :new
  end
end
