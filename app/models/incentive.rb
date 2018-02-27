class Incentive < ApplicationRecord
  include SettingTypes

  INCENTIVE = ["Build to Suit Proposal", "Cost Comparison", "Customer Search", "Demographic Information", "Existing Building Proposal", "Financial Review", "Incentive Information", "Relocation", "Packet", "Tax Abatement", "Other"]

  def self.create_configs( org_id )
    INCENTIVE.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
