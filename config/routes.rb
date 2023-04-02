Rails.application.routes.draw do
  devise_for :users

  root to: "forex#index"
  resources :posts, only: [:new, :create, :index]

  get '/forex', to: 'forex#index'
  get '/forex/pair', to: 'forex#show'
  get '/forex/convert', to: 'forex#convert'

  get '*path', to: 'application#render_404'
end
