Rails.application.routes.draw do
  root 'home#index'

  get '/dashboard' => 'dashboard#show'

  resources :operations, only: [:index, :show]

  resources :sources do
    resource :headers, only: :edit
    resource :preview, only: :show
    resource :download, only: :show
  end

  resource :sessions, only: :create
  get '/signin' => 'sessions#new'

  resource :users, only: [:new, :create]

  resources :works, only: [:index, :show, :new, :create]

  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_error'
end
