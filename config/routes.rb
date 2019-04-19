Rails.application.routes.draw do
  root 'landingpages#home'
  get 'about', to: 'landingpages#about'
  get '/contact' , to: 'landingpages#contact'
  get '/help', to: 'landingpages#help'
  get '/terms_of_use', to: 'landingpages#terms_of_use'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
