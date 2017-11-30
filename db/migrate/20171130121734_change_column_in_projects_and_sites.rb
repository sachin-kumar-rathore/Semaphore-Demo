class ChangeColumnInProjectsAndSites < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :unique_id, :project_number
    rename_column :sites, :property_number, :site_number
  end
end
