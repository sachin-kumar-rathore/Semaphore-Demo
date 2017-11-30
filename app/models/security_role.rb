class SecurityRole < ApplicationRecord
  PERMISSIONS = ["read", "create", "update", "delete", "assign"]
  belongs_to :organization
end
