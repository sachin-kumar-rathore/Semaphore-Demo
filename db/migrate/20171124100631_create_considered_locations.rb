class CreateConsideredLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :considered_locations do |t|
      t.string :status
      t.string :location
      t.string :city
      t.string :country
      t.string :city_abbreviation
      t.string :country_abbreviation
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
