class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.date :date
      t.text :description
      t.string :subject
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
