Rails.application.routes.draw do

  get 'track/index'
  get 'track/show'
  get 'track/create'
  get 'track/update'
  get 'track/destroy'


  root "top#top"
  

  
  resources :users do
    resources :tracks
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get    'login',  to: 'user_sessions#new'
  post   'login',  to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  # Defines the root path route ("/")
  # root "articles#index"
end
