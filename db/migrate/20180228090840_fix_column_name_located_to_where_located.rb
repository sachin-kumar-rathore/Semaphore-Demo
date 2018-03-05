class FixColumnNameLocatedToWhereLocated < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :located, :where_located
  end
end
