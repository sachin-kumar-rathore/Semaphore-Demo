class EliminationReason < ApplicationRecord
  include SettingTypes

  ELIMINATION_REASON = %i[Lackof_building_availability Lack_of_suitable_land_space NDA_breech 
                          No_financing_locally Not_close_enough_to_HQ Project_cancelled Other]

  def self.create_configs( org_id )
    ELIMINATION_REASON.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
