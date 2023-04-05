Rails.application.routes.draw do
  devise_for :users

  root to: 'forex#index'
  resources :posts, only: %i[new create index]

  scope :forex do
    get '/', to: 'forex#index'
    get '/pair', to: 'forex#show'
    get '/convert', to: 'forex#convert'
  end

  get '*path', to: 'application#render_404'
end
