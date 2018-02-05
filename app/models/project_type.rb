class ProjectType < ApplicationRecord
  include SettingTypes

  PROJECT_TYPES = ["Advanced Manfacturing", "Agriculture", "Big Box Retail", "Bio Medical", "Call Center", "Data Center", "Industrial", "Information Technology", "Manufacturing", "Restaurant", "Retail", "Warehouse"]

  scope :filter_by_id, ->(ids) { where('id IN (?)', ids).order(:id) }

  def self.create_configs( org_id )
    PROJECT_TYPES.each do |name|
      self.create!( name: name, status: "Active", organization_id: org_id )
    end
  end
end
