class IndustryType < ApplicationRecord
  include SettingTypes
  
  INDUSTRY_TYPES = ["Advanced Manufacturing", "Aerospace", "Ag Service", "Bioscience", "Energy", "Financial", "Food Processing", "Insurance", "Logistics Material Handling", "Military", "Retail"]

  def self.create_configs( org_id )
    INDUSTRY_TYPES.each do |name, status|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end