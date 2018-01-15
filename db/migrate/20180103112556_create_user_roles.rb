class CreateUserRoles < ActiveRecord::Migration[5.1]
  def change

    drop_table :roles
    drop_table :users_roles
    create_table :user_roles do |t|

      t.timestamps
    end
  end
end
