class ContactConsideredLocation < ApplicationRecord
  belongs_to :contact
  belongs_to :considered_location
end
