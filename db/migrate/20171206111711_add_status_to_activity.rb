class AddStatusToActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :converted, :boolean, default: false
  end
end
