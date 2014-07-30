Rails.application.routes.draw do
  root 'home#index'

  resources :sources do
    resource :headers, only: :edit
    resource :preview, only: :show
    resource :download, only: :show
  end

  resources :operations, only: [:index, :show]

  resources :works, only: [:index, :show, :new, :create]

  get '/dashboard' => 'dashboard#show'

  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_error'
end
