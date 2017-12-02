class ConsideredLocation < ApplicationRecord
  include SettingTypes
  has_many :contact_considered_locations, dependent: :destroy
  has_many :contacts, through: :contact_considered_locations
end
