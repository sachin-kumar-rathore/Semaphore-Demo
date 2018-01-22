class ProjectType < ApplicationRecord
  include SettingTypes

  PROJECT_TYPES = %i[Advanced_Manfacturing Agriculture Big_Box_Retail Bio_Medical Call_Center
                      Data_Center Industrial Information_Technology Manufacturing Restaurant
                      Retail Warehouse]

  def self.create_configs( org_id )
    PROJECT_TYPES.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
