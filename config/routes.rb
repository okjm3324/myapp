Rails.application.routes.draw do

  root "top#top"


  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :user_session, only: [:new, :create, :destroy]
  # Defines the root path route ("/")
  # root "articles#index"
end
