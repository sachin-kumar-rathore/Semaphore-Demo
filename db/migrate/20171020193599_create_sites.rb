class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.integer :organization_id
      t.integer :contact_id
      t.string :property_number
      t.string :property_name
      t.string :property_type
      t.string :address_line
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.float :available_acreage
      t.float :available_square_feet
      t.float :total_acreage
      t.float :total_square_feet
      t.float :latitude
      t.float :longitude
      t.string :business_unit

      t.timestamps
    end
  end
end
