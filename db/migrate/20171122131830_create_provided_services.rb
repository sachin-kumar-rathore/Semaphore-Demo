class CreateProvidedServices < ActiveRecord::Migration[5.1]
  def change
    create_table :provided_services do |t|
      t.string :name
      t.string :status
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
