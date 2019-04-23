Rails.application.routes.draw do
  root 'landingpages#home'
  get '/about', to: 'landingpages#about'
  get '/contact' , to: 'landingpages#contact'
  get '/help', to: 'landingpages#help'
  get '/terms_of_use', to: 'landingpages#terms_of_use'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :microposts, only:[:new, :create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
