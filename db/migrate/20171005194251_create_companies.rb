class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.integer :owner_id
      t.integer :subscription_id
      t.string :name
      t.integer :company_number
      t.string :business_sector
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :website
      t.string :email
      t.boolean :member_investor
      t.string :utility_provider
      t.text :notes
      t.string :business_unit
      t.integer :company_establishment_year
      t.integer :years_business_located

      t.timestamps
    end
  end
end
