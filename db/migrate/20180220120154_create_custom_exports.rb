class CreateCustomExports < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_exports do |t|
      t.string :name
      t.string :filters, array: true, default: []
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
