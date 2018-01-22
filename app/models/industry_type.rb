class IndustryType < ApplicationRecord
  include SettingTypes
  
  INDUSTRY_TYPES = %i[Advanced_Manufacturing Aerospace Ag_Service Bioscience Energy Financial
                      Food_Processing Insurance Logistics_Material_Handling Military Retail]

  def self.create_configs( org_id )
    INDUSTRY_TYPES.each do |name, status|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end