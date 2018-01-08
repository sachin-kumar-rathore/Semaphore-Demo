class AddRoleToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :security_role, foreign_key: true
    add_column :users, :active, :boolean
  end
end
