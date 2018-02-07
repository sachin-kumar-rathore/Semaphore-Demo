class Competition < ApplicationRecord
  include SettingTypes

  scope :filter_by_id, ->(ids) { where('id IN (?)', ids).order(:id) }
end
