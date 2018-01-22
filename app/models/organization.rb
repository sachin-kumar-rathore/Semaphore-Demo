class Organization < ApplicationRecord

  SETTINGS = ['project_types', 'industry_types', 'provided_services', 'competitions', 
              'sources', 'elimination_reasons', 'contact_categories', 'business_units',
              'contact_method_types', 'company_activity_types']

  CONFIG = %i[ProjectType IndustryType ProvidedService Source EliminationReason ContactCategory]
  CONFIG_WITHOUT_STATUS = %i[BusinessUnit SecurityRole ContactMethodType CompanyActivityType]
  
  has_many :users, dependent: :destroy

  has_many :contacts, dependent: :destroy
  has_many :sites
  has_many :projects
  has_many :tasks, through: :users
  has_many :emails, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :companies, dependent: :destroy
  has_many :project_types, dependent: :destroy
  has_many :industry_types, dependent: :destroy
  has_many :provided_services, dependent: :destroy
  has_many :competitions, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :contact_categories, dependent: :destroy
  has_many :elimination_reasons, dependent: :destroy
  has_many :business_units, dependent: :destroy
  has_many :contact_method_types, dependent: :destroy
  has_many :company_activity_types, dependent: :destroy
  has_many :considered_locations, dependent: :destroy
  has_many :security_roles, dependent: :destroy
  has_many :activities, dependent: :destroy
    
  validates_presence_of :name, :primary_contact_first_name, :primary_contact_phone, :primary_contact_email
  validates_format_of :primary_contact_email, with: Devise::email_regexp

  after_create :create_admin_role, :create_config, :create_config_without_status


  def create_admin_role(name=nil)
    name = name || "Administrator"
    self.security_roles.create!(name: name,
      project_permissions: {"read"=>"All", "assign"=>"All", "create"=>"All", "delete"=>"All", "update"=>"All"},
      site_permissions: {"read"=>"All", "assign"=>"All", "create"=>"All", "delete"=>"All", "update"=>"All"},
      contact_permissions: {"read"=>"All", "assign"=>"All", "create"=>"All", "delete"=>"All", "update"=>"All"},
      configuration_permissions: {"read"=>"All", "assign"=>"All", "create"=>"All", "delete"=>"All", "update"=>"All"},
      user_permissions: {"read"=>"All", "assign"=>"All", "create"=>"All", "delete"=>"All", "update"=>"All"},
      company_permissions: {"read"=>"All", "assign"=>"All", "create"=>"All", "delete"=>"All", "update"=>"All"} ) 
  end

  def create_config
    CONFIG.each do |config|
      config.to_s.constantize::create_configs(self.id)
    end
  end

  def create_config_without_status
    CONFIG_WITHOUT_STATUS.each do |config|
      config.to_s.constantize::create_configs(self.id)
    end
  end
end
