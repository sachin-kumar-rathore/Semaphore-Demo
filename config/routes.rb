Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :contacts
  resources :organizations, only: [:edit, :update]
  resources :dashboard, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    root 'users/registrations#new'
  end
end
