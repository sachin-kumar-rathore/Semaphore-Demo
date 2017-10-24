class AddAssigneeToTasks < ActiveRecord::Migration[5.1]
  def change
    remove_column :tasks, :assigned_to, :integer
    add_column :tasks, :assignee_id, :integer
  end
end
