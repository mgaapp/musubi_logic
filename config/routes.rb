Rails.application.routes.draw do
  namespace :public do
    get "requests/index"
    get "requests/show"
    get "requests/new"
  end
  resource :session
  resources :passwords, param: :token
  root to: "homes#top"
  get "/homes/about" => "homes#about", as: "about"
  resources :users, only: [ :show ]
  resources :inventories, only: [:index]
  resources :inventory_histories, only: [:create]
  resources :requests, only: [:index, :show, :new, :create]
  resources :posts
  resources :assets, only: [:index]
  namespace :admin do
   resources :users
   resources :requests, only: [:index, :show, :update]
   resources :categories, only: [:new, :create, :index]
   resources :inventories, only: [:index, :new, :create, :edit, :update]
   resources :inventory_histories, only: [:index]
   resources :assets
  end
  
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
