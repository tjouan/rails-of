Rails.application.routes.draw do
  root 'home#index'

  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_error'

  get '/dashboard' => 'dashboard#show'

  resources :operations, only: %i[index show]

  resources :sessions, only: :create
  get '/signin' => 'sessions#new'
  get '/signout' => 'sessions#destroy'

  resources :sources do
    resource :headers, only: :edit
    resource :preview, only: :show
    resource :download, only: :show
  end

  resources :trainings, only: :index

  resources :users, only: %i[new create]

  resources :works, only: %i[index show new create]

  namespace :admin do
    get '', to: 'dashboard#show'
    resources :articles
    resources :operations
    resources :sources, only: %i[index show]
    resources :users
    resources :works, only: %i[index show]
  end
end
