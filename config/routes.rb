Rails.application.routes.draw do
  devise_for :users
  resources :events, :only => [:index, :new, :create, :show]

  resources :tickets
  root :to => redirect('/index.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
