class CreateCustomModules < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_modules do |t|
      t.string :name
      t.string :controller_name

      t.timestamps
    end
  end
end
