class ChangingSchemaOfContact < ActiveRecord::Migration[5.1]
  def change
    rename_column :contacts, :company_id, :organization_id
    rename_column :contacts, :city, :city_state_zip
    rename_column :contacts, :phone_number, :phone_number_1
    rename_column :contacts, :zip_code, :fax
    rename_column :contacts, :country, :website

    add_column :contacts, :category, :string
    add_column :contacts, :title, :string
    add_column :contacts, :address_line_2, :string
    add_column :contacts, :phone_number_2, :string
    add_column :contacts, :cell_phone, :string
    add_column :contacts, :notes, :text
  end
end
