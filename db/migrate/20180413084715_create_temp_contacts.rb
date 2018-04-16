class CreateTempContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :temp_contacts do |t|
      t.string :name
      t.string :email
      t.string :address_line_1
      t.string :phone_number_1
      t.string :phone_number_2
      t.string :city_state_zip
      t.string :title
      t.string :cell_phone
      t.text   :notes
      t.boolean :exist
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
