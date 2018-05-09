class RenameCustomModules < ActiveRecord::Migration[5.1]
  def change
    rename_table :custom_modules, :general_modules
    add_column :general_modules, :is_custom, :boolean, default: false
  end
end
