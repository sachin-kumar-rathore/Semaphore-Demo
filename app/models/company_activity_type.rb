class CompanyActivityType < ApplicationRecord
  belongs_to :organization
  validates :name, presence: true

  COMPANY_ACTIVITY_TYPE = %i[business_Assistance Quarterly_Review Retention_Visit Survey]

  def self.create_configs( org_id )
    COMPANY_ACTIVITY_TYPE.each do |name|
      self.create!( name: name, organization_id: org_id )
    end
  end
end
