class SecurityRole < ApplicationRecord
  PERMISSIONS = ["read", "create", "update", "delete", "assign"]

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :organization_id
  belongs_to :organization
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
end
