class ContactCategory < ApplicationRecord
  include SettingTypes

  CONTACT_CATEGORY = ["C-Level", "Executive", "Client", "Community", "Partner", "Investor", "Local Developer", "Local Re Broker", "Manager", "Owner", "Silent Partner", "Site Selection Consultant"]

  def self.create_configs( org_id )
    CONTACT_CATEGORY.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
