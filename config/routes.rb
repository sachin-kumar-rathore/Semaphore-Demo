Rails.application.routes.draw do


  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :companies do
    member do
      patch :company_info_update
      patch :history_update
      patch :facilities_update
      patch :products_and_services_update
      patch :local_employment_update
      patch :union_representation_update
    end
    resources :contacts, controller: 'company_contacts' do
      member do
        post :attach_contact_to_company
      end
      collection do
        get :show_existing_contacts
      end
    end
  end

  resources :organizations, only: [:edit, :update]
  resources :dashboard, only: [:index]

  resources :contacts do
    collection do
      post :import_contacts, as: :import
    end
  end

  resources :sites do
    collection do
      get :find_contact
    end
  end

  resources :files do
    member do
      get :show_projects
      post :attach_project_to_file
    end
  end
  resources :dashboard, only: [:index]
  resources :projects, only: [:new, :index, :create, :edit, :update, :show] do
    resources :tasks, controller: 'project_tasks'
    resources :notes, except: [:edit]
    resources :files, controller: 'project_files'
    resources :contacts, controller: 'project_contacts', only: [:index, :new, :create, :show, :update, :destroy] do
      member do
        post :attach_contact_to_project
      end
      collection do
        get :show_existing_contacts
      end
    end
    resources :sites, controller: 'project_sites', only: [:index, :new, :create, :show, :update, :destroy] do
      member do
        post :attach_site_to_project
      end
      collection do
        get :show_existing_sites
      end
    end

    resources :emails, controller: 'project_emails', only: [:index, :create, :destroy, :show] do
      member do
        get :show_existing_contacts
        post :attach_contact_to_email
      end
    end

  end
  


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    root 'users/registrations#new'
  end

  resources :tasks do
    collection do
      get :filter_tasks
    end
  end

  resources :emails, only: [:index, :create, :destroy, :show] do
    member do
      get :show_existing_contacts, :show_existing_projects
      post :attach_contact_to_email, :attach_project_to_email
    end
  end

end
