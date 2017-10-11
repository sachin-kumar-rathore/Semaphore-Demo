class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :url
      t.string :primary_contact_first_name
      t.string :primary_contact_last_name
      t.string :primary_contact_phone
      t.string :primary_contact_email

      t.timestamps
    end
  end
end
