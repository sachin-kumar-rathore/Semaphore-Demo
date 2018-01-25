class EliminationReason < ApplicationRecord
  include SettingTypes

  ELIMINATION_REASON = ["Lack of building availability", "Lack of suitable land space", "NDA breech", "No financing locally", "Not close enough to HQ", "Project cancelled", "Other"]

  def self.create_configs( org_id )
    ELIMINATION_REASON.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
