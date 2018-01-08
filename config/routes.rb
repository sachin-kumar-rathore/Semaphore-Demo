Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'admins/sessions' }
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
    collection do
      get :check_companies_number_validity
    end
    resources :contacts, controller: 'company_contacts' do
      member do
        post :attach_contact_to_company
      end
      collection do
        get :show_existing_contacts
      end
    end
    resources :projects, controller: 'company_projects', only: [:index] do
      member do
        post :attach_project_to_company
      end
      collection do
        get :show_existing_projects
      end
    end
    resources :activities, controller: 'company_activities'
  end

  resources :organizations, only: %i[show edit update index] do
    member do
      get :sign_in_as_admin
    end
    member do
      get :sign_in_as_user
    end
    resources :users, controller: 'manage_users', only: %i[edit update]
  end

  resources :dashboard, only: [:index]

  resources :contacts do
    collection do
      post :import_contacts, as: :import
    end
  end

  resources :sites do
    collection do
      get :find_contact
      get :check_sites_number_validity
      post :import_sites, as: :import
    end
  end

  resources :files do
    member do
      get :show_projects
      post :attach_project_to_file
    end
  end
  resources :dashboard, only: [:index]
  resources :projects, only: %i[new index create edit update show] do
    resources :tasks, controller: 'project_tasks'
    resources :notes, except: [:edit]
    resources :files, controller: 'project_files'
    resources :contacts, controller: 'project_contacts',
                         only: %i[index new create show update destroy] do
      member do
        post :attach_contact_to_project
      end
      collection do
        get :show_existing_contacts
      end
    end
    resources :sites, controller: 'project_sites',
                      only: %i[index new create show update destroy] do
      member do
        post :attach_site_to_project
      end
      collection do
        get :show_existing_sites
      end
    end

    resources :emails, controller: 'project_emails',
                       only: %i[index create destroy show] do
      member do
        get :show_existing_contacts
        post :attach_contact_to_email
      end
    end

    collection do
      get :check_projects_number_validity
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboard#index'

  resources :tasks do
    collection do
      get :filter_tasks
    end
  end

  resources :emails, only: %i[index create destroy show] do
    member do
      get :show_existing_contacts, :show_existing_projects_and_activities
      post :attach_contact_to_email, :attach_project_or_activity_to_email
    end
  end

  resources :manage_configurations
  resources :considered_locations do
    member do
      post :attach_contact
      get :show_contacts
      delete :remove_contact
    end
  end

  resources :security_roles

  resources :activities do
    resources :notes, controller: 'activity_notes'
    resources :files, controller: 'activity_files'
    resources :tasks, controller: 'activity_tasks'
    resources :emails, controller: 'activity_emails'
    collection do
      get :check_activities_number_validity
    end
  end

  resources :imports, only: [:index]
  resources :manage_users do
    member do
      get :edit_invitation
      patch :update_invitation
    end
  end
end
