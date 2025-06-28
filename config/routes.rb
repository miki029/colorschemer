Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:show] # ユーザーマイページへのルーティング
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #  get "up" => "rails/health#show", as: :rails_health_check
  get "hello/index" => "hello#index"
  get "hello/link" => "hello#link"
  get 'tweets/:tweet_id/likes' => 'likes#create'
  get 'tweets/:tweet_id/likes/:id' => 'likes#destroy'
  root "hello#index"
  resources :perfumes

  Rails.application.routes.draw do
    resources :tweets do
      resources :likes, only: [:create, :destroy]
      resources :comments, only: [:create]
    end
  # Defines the root path route ("/")
  end
end