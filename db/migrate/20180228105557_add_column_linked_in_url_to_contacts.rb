class AddColumnLinkedInUrlToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :linkedin_url, :string
  end
end
