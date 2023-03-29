Rails.application.routes.draw do
  root to: "posts#index"
  
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  resources :posts, only: [:new, :create, :index]

  get '/forex', to: 'forex#index'

  
  #get '/forex', to: 'forex#index'
  #get '/forex/pairs/:pairs/:how_much', to: 'forex#show_pairs'
end
