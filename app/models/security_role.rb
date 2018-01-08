class SecurityRole < ApplicationRecord
  PERMISSIONS = ["read", "create", "update", "delete", "assign"]

  validates :name, presence: true, uniqueness: true
  belongs_to :organization, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
end
