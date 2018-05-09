class OrganizationPackage < ApplicationRecord

  belongs_to :package
  belongs_to :organization
end