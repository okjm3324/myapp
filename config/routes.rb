Rails.application.routes.draw do
  get 'albums/index'
  get 'albums/search'
  resources :tracks
  root "top#top"
  
  resources :users do
    resources :tracks do
      collection do
        get 'search_artist'
        get 'search_album'
        get 'search_track'
      end
    end

    get '/users/:user_id/tracks/search', to: 'tracks#search_artist', as: :search
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get    'login',  to: 'user_sessions#new'
  post   'login',  to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  # Defines the root path route ("/")
  # root "articles#index"
  get '/auth/spotify/callback', to: 'user_sessions#spotify_callback'
  get '/play', to: 'tracks#play'
end
