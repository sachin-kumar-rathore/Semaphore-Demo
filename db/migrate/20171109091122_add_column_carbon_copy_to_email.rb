class AddColumnCarbonCopyToEmail < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :cc, :string
  end
end
