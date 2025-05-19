Rails.application.routes.draw do
  devise_for :users
  
  root 'home#index'
  
  resources :friend_requests
  resources :goals
  resources :users, only: [ :index ]
  
  get "/search" => "finds#search"
  
  # NOTE: These routes from the users, can go into the collection resources, eg:
  # resources :photos do
  #   collection do
  #     get "search"
  #   end
  # end
  get ":username" => "users#show", as: :user

  get ":username/completed" => "users#completed", as: :completed

  get ":username/pending" => "users#pending", as: :pending
  
  get ":username/feed" => "users#feed", as: :feed
  
  
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
