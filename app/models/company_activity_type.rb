class CompanyActivityType < ApplicationRecord
  belongs_to :organization, dependent: :destroy
end
