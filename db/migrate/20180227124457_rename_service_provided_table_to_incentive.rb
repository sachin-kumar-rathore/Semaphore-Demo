class RenameServiceProvidedTableToIncentive < ActiveRecord::Migration[5.1]
  def change
    rename_table :provided_services, :incentives

    rename_column :projects, :provided_service_id, :incentive_id
    rename_column :activities, :provided_service_id, :incentive_id
  end
end
