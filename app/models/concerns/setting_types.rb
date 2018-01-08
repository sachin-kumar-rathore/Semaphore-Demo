module SettingTypes
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(status: "Active")}
    belongs_to :organization, dependent: :destroy
  end

end