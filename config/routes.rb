Rails.application.routes.draw do
  root "top#top"
  
  resources :users do
    member do
      get :likes, :following, :followers
    end
    collection do
      get 'refresh_token'
    end
  end

  resources :tracks do
    resource :likes, only: [:index, :create, :destroy]
    resources :comments, only: [:create, :destroy]
      collection do
        get 'search_artist'
        get 'search_album'
        get 'search_track'
      end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get    'login',  to: 'user_sessions#new'
  post   'login',  to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout
  resources :relationships,       only: [:create, :destroy]

  # Defines the root path route ("/")
  # root "articles#index"
  get '/auth/spotify/callback', to: 'user_sessions#spotify_callback'
  get '/play', to: 'tracks#play'
end
