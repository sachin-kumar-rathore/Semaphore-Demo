class GeneralModule < ApplicationRecord
  validates_presence_of :name, :controller_name

  has_many :package_modules, dependent: :destroy
  has_many :packages, through: :package_modules

  scope :custom_modules, -> { where(is_custom: true) }
  scope :side_bar_modules, -> { where(side_bar_enabled: true) }
end
