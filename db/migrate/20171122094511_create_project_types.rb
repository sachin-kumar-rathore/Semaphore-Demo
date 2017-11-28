class CreateProjectTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :project_types do |t|
      t.string :name
      t.string :status

      t.timestamps
    end
  end
end
