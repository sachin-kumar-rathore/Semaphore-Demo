class CreateContactMethodTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_method_types do |t|
      t.string :name
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
