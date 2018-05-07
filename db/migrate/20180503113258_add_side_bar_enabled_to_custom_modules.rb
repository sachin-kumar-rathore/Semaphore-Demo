class AddSideBarEnabledToCustomModules < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_modules, :side_bar_enabled, :boolean, default: :true
  end
end
