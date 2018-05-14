class Package < ApplicationRecord
  attr_accessor :module_ids

  validates :name, presence: true
  validates_uniqueness_of :name

  has_many :package_modules, dependent: :destroy
  has_many :general_modules, through: :package_modules
  has_many :organization_packages, dependent: :destroy
  has_many :organizations, through: :organization_packages
end
