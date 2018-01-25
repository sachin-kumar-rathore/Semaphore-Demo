class SecurityRole < ApplicationRecord
  PERMISSIONS = ["read", "create", "update", "delete", "assign"]

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :organization_id
  belongs_to :organization
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  SECURITY_ROLES = ["Board", "Contact/Visit Review", "Project Manager", "Read Only User"]

  def self.create_configs( org_id )
    organization =  Organization.find org_id
    SECURITY_ROLES.each do |name|
      organization.create_admin_role(name)
    end
  end
end
