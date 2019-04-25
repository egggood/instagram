Rails.application.routes.draw do
  root 'landingpages#home'
  get '/about', to: 'landingpages#about'
  get '/contact' , to: 'landingpages#contact'
  get '/help', to: 'landingpages#help'
  get '/terms_of_use', to: 'landingpages#terms_of_use'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :reply, only:[:create, :destroy]
  resources :users do
    member do
      get :following, :followers, :password_edit
      post :password_update
    end
    collection do
      get :password_new
    end
  end
  resources :users
  resources :microposts, only:[:new, :show, :create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
