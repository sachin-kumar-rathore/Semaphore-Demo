class ChangePropertyNameToName < ActiveRecord::Migration[5.1]
  def change
    rename_column :sites, :property_name, :name
  end
end
