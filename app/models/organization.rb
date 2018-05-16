class Organization < ApplicationRecord

  SETTINGS = ['project_types', 'industry_types', 'incentives', 'competitions',
              'sources', 'elimination_reasons', 'contact_categories', 'business_units',
              'contact_method_types', 'company_activity_types']

  CONFIG = %i[ProjectType IndustryType Incentive Source EliminationReason ContactCategory]
  CONFIG_WITHOUT_STATUS = %i[BusinessUnit SecurityRole ContactMethodType CompanyActivityType]

  SECURITY_ROLES_HASH = { boards: "Board", contact_or_visit_review_users: "Contact/Visit Review", project_managers: "Project Manager", read_only_users: "Read Only User", administrators: "Administrator"}
  
  attr_accessor :package_id

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
  has_one :organization_package, dependent: :destroy
  has_one :package, through: :organization_package
  has_many :suspicious_activities, dependent: :destroy
    
  validates_presence_of :name, :primary_contact_first_name, :primary_contact_phone, :primary_contact_email
  validates_format_of :primary_contact_email, with: Devise::email_regexp

  after_create :assign_default_package, :create_admin_role, :create_config, :create_config_without_status

  SECURITY_ROLES_HASH.each do |arg, val|
    define_method(arg) do
      security_roles.where(name: val).map(&:users).flatten.compact
    end
  end

  def create_admin_role(name=nil, accesses={})
    name = name || "Administrator"
    self.enabled_modules.pluck(:controller_name).map { |module_controller| accesses[module_controller] = {access: 'Write', status: true }.stringify_keys } unless accesses.present?
    self.security_roles.create!(name: name, accesses: accesses) 
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

  def assign_default_package
    create_organization_package(package_id: Package.find_by(name: 'default-standard').try(:id))
  end

  def enabled_modules
    package.general_modules
  end

  def custom_modules
    GeneralModule.custom_modules.where(id: custom_module_ids).order('id asc')
  end

  def enabled_default_module?(module_controller)
    enabled_modules.pluck(:controller_name).include?(module_controller)
  end

  def enabled_custom_module?(module_controller)
    custom_module_ids.include?(GeneralModule.custom_modules.find_by_controller_name(module_controller).try(:id))
  end

  def enabled_module?(module_controller)
    enabled_default_module?(module_controller) || enabled_custom_module?(module_controller)
  end
end
