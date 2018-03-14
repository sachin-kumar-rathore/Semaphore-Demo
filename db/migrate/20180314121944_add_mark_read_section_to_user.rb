class AddMarkReadSectionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :mark_read_sections, :string, array: true, default: []
  end
end
