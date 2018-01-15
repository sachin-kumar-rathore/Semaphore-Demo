class AddUserAndRolesToUserRole < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_roles, :user, foreign_key: true
    add_reference :user_roles, :security_role, foreign_key: true
  end
end
