class ConsideredLocation < ApplicationRecord
  scope :active, -> { where(status: "Active")}
  belongs_to :organization
  validates :location, presence: true
  has_many :contact_considered_locations, dependent: :destroy
  has_many :contacts, through: :contact_considered_locations
end
