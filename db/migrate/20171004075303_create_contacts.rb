class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.integer   :company_id
      t.string    :name
      t.string    :email
      t.string    :phone_number
      t.string    :address_line_1
      t.string    :city
      t.string    :zip_code
      t.string    :country
      t.string    :business_unit

      t.timestamps
    end
  end
end
