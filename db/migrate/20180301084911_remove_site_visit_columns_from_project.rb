class RemoveSiteVisitColumnsFromProject < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :site_visit_1
    remove_column :projects, :site_visit_2
    remove_column :projects, :site_visit_3
  end
end
