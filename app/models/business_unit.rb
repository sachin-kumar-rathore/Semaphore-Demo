class BusinessUnit < ApplicationRecord
  belongs_to :organization, dependent: :destroy
end
