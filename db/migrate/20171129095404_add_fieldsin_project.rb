class AddFieldsinProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :considered_location, :string
    add_column :projects, :competition, :string
    add_column :projects, :provided_service, :string
  end
end
