class CreateCompetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :competitions do |t|
      t.string :name
      t.string :status
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
