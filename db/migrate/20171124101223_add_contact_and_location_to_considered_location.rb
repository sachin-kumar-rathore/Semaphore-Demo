class AddContactAndLocationToConsideredLocation < ActiveRecord::Migration[5.1]
  def change
    add_reference :contact_considered_locations, :contact, foreign_key: true
    add_reference :contact_considered_locations, :considered_location, foreign_key: true
  end
end
