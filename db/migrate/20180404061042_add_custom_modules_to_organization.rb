class AddCustomModulesToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :custom_module_ids, :integer, array: true, default: []
  end
end
