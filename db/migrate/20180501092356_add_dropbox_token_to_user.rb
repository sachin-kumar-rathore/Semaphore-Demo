class AddDropboxTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :dropbox_token, :string
  end
end
