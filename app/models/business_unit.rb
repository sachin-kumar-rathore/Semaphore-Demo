class BusinessUnit < ApplicationRecord
  belongs_to :organization
  validates :name, presence: true

  BUSINESS_UNIT = ["Default", "Executive", "Investor Relations"]

  def self.create_configs( org_id )
    BUSINESS_UNIT.each do |name|
      self.create!( name: name, organization_id: org_id )
    end
  end
end
