Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'admins/sessions', passwords: 'admins/passwords' }
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', devise_authy: 'users/devise_authy' },
                     path_names: {  verify_authy: "/verify-token",
                                    enable_authy: "/enable-two-factor",
                                    verify_authy_installation: "/verify-installation",
                                    authy_onetouch_status: "/onetouch-status"
                                  }

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
      get :export
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
  get 'exports/companies/export_form', to: 'companies#export_form', as: 'export_form_companies'
  get 'exports/projects/export_form', to: 'projects#export_form', as: 'export_form_projects'
  get 'imports/contacts/outlook', to: 'outlook_contacts#index', as: 'outlook_contacts'
  
  get :authorize_user, to: 'auth#get_token'

  resources :organizations, only: %i[show edit update index] do
    member do
      get :sign_in_as_admin
    end
    member do
      get :sign_in_as_user
      patch :toggle_access_custom_module
    end
    resources :users, controller: 'manage_users', only: %i[edit update] do
      member do
        patch :mark_section_as_read
        get :get_section_information
      end
    end
  end

  resources :contacts do
    collection do
      post :import_contacts, as: :import
      get :export
    end
  end

  resources :outlook_contacts, only: %[show] do
    post :import_or_update_contact, as: :import_or_update, on: :collection
  end

  resources :sites do
    collection do
      get :find_contact
      get :check_sites_number_validity
      post :import_sites, as: :import
      post :lois_import
    end
  end

  resources :files do
    member do
      get :show_projects
      post :attach_project_to_file
    end
  end
  resources :dashboard, only: [:index] do
    collection do
      get :tasks
      get :activity
      get :emails
      get :projects
    end
  end
  resources :projects do
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
      get :export
    end

    member do
      get :logs
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

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
  resources :reports, only: [:index] do
    collection do
      post :yearly_report
      post :monthly_report
      get :sites
      get :projects
      post :download_sites
      post :download_projects
      get :yearly
      get :monthly
      get :highcharts
      get :highchart_report
    end
  end

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
  resources :exports, only: [:index]

  resources :custom_exports, only: [:destroy]  do
    collection do
      post :save_custom_configs
    end
    member do
      post :edit_custom_configs
    end
  end

  resources :manage_users do
    member do
      get :edit_invitation
      patch :update_invitation
      patch :update_user_details
    end
  end

  resources :search, only: [:index]

  get 'organization_details' => 'organizations#edit_details'
  get 'my_details', to: 'manage_users#user_details'

  resources :project_logs, only: [:index]

  resources :transactional_emails, only: [:edit, :index, :update]

  resources :section_guides, only: %i[index edit update]

  resources :custom_modules, only: %i[index edit update]
  resources :module_one, only: %i[index]
  resources :module_two, only: %i[index]
  
  resources :dropboxes, only: %i[index destroy] do
    collection do
      get :connect
      post :verify_code
      get :content
      post :select_files
      post :sync_files
    end
    member do
      get :download_dropbox_file
    end
  end

  resources :packages, except: %i[edit update]
end
