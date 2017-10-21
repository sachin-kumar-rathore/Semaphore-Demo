Rails.application.routes.draw do


  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :companies

  resources :organizations, only: [:edit, :update] do
    resources :contacts do
      collection do
        post :import_contacts, as: :import
      end
    end

    resources :sites
  end
  resources :dashboard, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    root 'users/registrations#new'
  end

end
