class ModifySecurityRoles < ActiveRecord::Migration[5.1]
  def change
    remove_column :security_roles, :project_permissions
    remove_column :security_roles, :user_permissions
    remove_column :security_roles, :configuration_permissions
    remove_column :security_roles, :site_permissions
    remove_column :security_roles, :contact_permissions
    remove_column :security_roles, :company_permissions
    add_column :security_roles, :accesses, :hstore, default: {}
  end
end
