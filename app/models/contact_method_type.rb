class ContactMethodType < ApplicationRecord
  belongs_to :organization, dependent: :destroy
end
