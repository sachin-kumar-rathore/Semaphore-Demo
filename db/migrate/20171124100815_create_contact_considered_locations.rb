class CreateContactConsideredLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_considered_locations do |t|

      t.timestamps
    end
  end
end
