class ChangeColumnTypeOfNewJobInProject < ActiveRecord::Migration[5.1]
  def change
    change_column :projects, :new_jobs, 'integer USING CAST(new_jobs AS integer)', default: 0
    change_column :projects, :retained_jobs, 'integer USING CAST(retained_jobs AS integer)', default: 0
  end
end
