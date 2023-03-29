Rails.application.routes.draw do
  devise_for :users

  root to: "posts#index"
  resources :posts, only: [:new, :create, :index]

  get '/forex', to: 'forex#index'
  get '/forex/pair', to: 'forex#get_currency_pair'
  get '/forex/convert', to: 'forex#convert'
end
