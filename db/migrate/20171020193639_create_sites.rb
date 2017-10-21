class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.integer :organization_id
      t.string :peoperty_number
      t.string :propoerty_name
      t.string :type
      t.string :address_line
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.float :available_acreage
      t.float :available_square_feet
      t.float :tota_acreage
      t.float :total_square_feet
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
