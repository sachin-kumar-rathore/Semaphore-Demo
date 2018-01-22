class ProvidedService < ApplicationRecord
  include SettingTypes

  PROVIDED_SERVICE = %i[Build_to_Suit_Proposal Cost_Comparison Customer_Search Demographic_Information
                        Existing_Building_Proposal Financial_Review Incentive_Information Other
                        Relocation Packet Tax_Abatement]

  def self.create_configs( org_id )
    PROVIDED_SERVICE.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
