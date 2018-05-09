class PackageModule < ApplicationRecord

  belongs_to :package
  belongs_to :general_module
end