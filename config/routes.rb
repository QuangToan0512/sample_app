Rails.application.routes.draw do

  root "static_pages#home"
  get "home", to: "static_pages#home"
  get "help", to: "static_pages#help"
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  get "signup", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users
  resource :account_activations, only: [:edit]
  resources :password_resets, expect: %i(show index destroy)
end
