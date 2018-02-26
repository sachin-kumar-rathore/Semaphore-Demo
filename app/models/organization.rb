class Organization < ApplicationRecord

  SETTINGS = ['project_types', 'industry_types', 'incentives', 'competitions',
              'sources', 'elimination_reasons', 'contact_categories', 'business_units',
              'contact_method_types', 'company_activity_types']

  CONFIG = %i[ProjectType IndustryType Incentive Source EliminationReason ContactCategory]
  CONFIG_WITHOUT_STATUS = %i[BusinessUnit SecurityRole ContactMethodType CompanyActivityType]

  SECURITY_ROLES_HASH = { boards: "Board", contact_or_visit_review_users: "Contact/Visit Review", project_managers: "Project Manager", read_only_users: "Read Only User", administrators: "Administrator"}
  
  mount_uploader :logo, FileUploader
  
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
  has_many :incentives, dependent: :destroy
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

  SECURITY_ROLES_HASH.each do |arg, val|
    define_method(arg) do
      security_roles.where(name: val).map(&:users).flatten.compact
    end
  end

  def create_admin_role(name=nil)
    name = name || "Administrator"
    self.security_roles.create!(name: name,
      project_permissions: SecurityRole::PERMIT_ALL,
      site_permissions: SecurityRole::PERMIT_ALL,
      contact_permissions: SecurityRole::PERMIT_ALL,
      configuration_permissions: SecurityRole::PERMIT_ALL,
      user_permissions: SecurityRole::PERMIT_ALL,
      company_permissions: SecurityRole::PERMIT_ALL ) 
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

  def custom_module_status(custom_module_id)
    custom_module_ids.include?(custom_module_id) ? 'Active' : 'Inactive'
  end
end
