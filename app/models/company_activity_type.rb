class CompanyActivityType < ApplicationRecord
  belongs_to :organization
  validates :name, presence: true
end
