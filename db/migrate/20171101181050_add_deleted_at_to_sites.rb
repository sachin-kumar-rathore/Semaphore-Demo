class AddDeletedAtToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :deleted_at, :datetime
    add_index :sites, :deleted_at
  end
end
