Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  
  # Role-based routes
  get 'clients/show', to: 'clients#show'
  post 'clients/create_request', to: 'clients#create_request'
  get 'workers/show', to: 'workers#show'
  
  # Contract routes
  resources :contracts, only: [:new, :create], except: [:index] do
    member do
      get :download
      post :accept
    end
  end
  
  # Root path for non-authenticated users
  devise_scope :user do
    root 'devise/sessions#new'
  end
end