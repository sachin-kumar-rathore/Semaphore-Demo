class ChangeColumnNamesInSecurityRole < ActiveRecord::Migration[5.1]
  def change
    rename_column :security_roles, :projects, :project_permissions
    rename_column :security_roles, :users, :user_permissions
    rename_column :security_roles, :configuration, :configuration_permissions
    rename_column :security_roles, :sites, :site_permissions
    rename_column :security_roles, :contacts, :contact_permissions
    rename_column :security_roles, :companies, :company_permissions
  end
end
