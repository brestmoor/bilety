Rails.application.routes.draw do
  get 'rows/index'

  get 'accounts/show'
  get 'accounts/edit'
  post 'accounts/edit'

  devise_for :admins
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :events
  resources :tickets
  resources :accounts
  resources :rows, only: [:index]
  root :to => redirect('/index.html')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
