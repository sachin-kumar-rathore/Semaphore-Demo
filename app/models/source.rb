class Source < ApplicationRecord
  include SettingTypes

  SOURCE = %i[ Business_Publication Direct_Inquiry State_ED_Dept regional_EDC Utility_ED Trade_Show/Conf Local_Bus_Referral Other]
  
  def self.create_configs( org_id )
    SOURCE.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
