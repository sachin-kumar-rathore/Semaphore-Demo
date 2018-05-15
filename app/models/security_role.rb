class SecurityRole < ApplicationRecord
  PERMISSIONS = ["Read", "Write"]

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :organization_id
  belongs_to :organization
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  SECURITY_ROLES = ["Board", "Contact/Visit Review", "Project Manager", "Read Only User"]

  def self.create_configs( org_id )
    organization, accesses =  Organization.find org_id, {}
    organization.enabled_modules.pluck(:controller_name).map { |module_controller| accesses[module_controller] = {access: 'Write', status: true }.stringify_keys }
    SECURITY_ROLES.each do |name|
      organization.create_admin_role(name, accesses)
    end
  end
end
