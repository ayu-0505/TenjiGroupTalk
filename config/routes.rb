Rails.application.routes.draw do
  root 'home#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#auth_failure'
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  get 'dashboard', to: 'dashboard#index'
  resources :sessions, only: %i[create destroy]
  resources :notifications, only: %i[update]

  namespace :api do
    resource :braille_converter, only: :create
  end

  resources :users, only: %i[show edit update destroy]
  resources :groups do
    resources :talks
    resources :memberships, only: %i[destroy]
    resources :invitations, only: %i[create]
  end
  resources :talks, only: :show do
    resources :comments, only: %i[edit create update destroy]
    resources :subscriptions, only: %i[create destroy]
  end
  get 'welcome', to: 'home#welcome'
  get 'terms', to: 'home#terms'
  get 'privacy', to: 'home#privacy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
