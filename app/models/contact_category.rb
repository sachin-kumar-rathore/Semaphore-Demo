class ContactCategory < ApplicationRecord
  include SettingTypes

  CONTACT_CATEGORY = %i[C-Level Executive Client Community Partner Investor Local_Developer
                        Local_Re_broker Manager Owner Silent_Partner Site_Selection_Consultant]

  def self.create_configs( org_id )
    CONTACT_CATEGORY.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
