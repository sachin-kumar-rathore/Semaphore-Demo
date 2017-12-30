class AddFieldsInSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :special_district, :string
  end
end
