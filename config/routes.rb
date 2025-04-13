Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  
  # Role-based routes
  get 'clients/show', to: 'clients#show'
  get 'workers/show', to: 'workers#show'
  
  # Root path for non-authenticated users
  devise_scope :user do
    root 'devise/sessions#new'
  end
end
