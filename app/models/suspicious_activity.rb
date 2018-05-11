class SuspiciousActivity < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :general_module
end
