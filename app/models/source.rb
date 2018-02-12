class Source < ApplicationRecord
  include SettingTypes

  SOURCE = ["Business Publication", "Direct Inquiry", "State ED Dept", "Regional EDC", "Utility ED", "Trade Show/Conf.", "Local Bus Referral", "Other"]

  scope :filter_by_id, ->(ids) { where('id IN (?)', ids).order(:id) }
  
  def self.create_configs( org_id )
    SOURCE.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
