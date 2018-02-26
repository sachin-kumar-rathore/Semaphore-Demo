class AddProjectManagerToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :project_manager_id, :integer
  end
end
