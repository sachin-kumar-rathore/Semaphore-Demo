class AddOrganizationNameToContact < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :organization_name, :string
  end
end
