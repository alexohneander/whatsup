require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "dashboard#index"
  resources :dashboard
  
  namespace :jobs do
    resources :http_checks
  end

  # Sidekiq UI
  authenticate :admin do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "healthz" => "healthchecks#status"
end
