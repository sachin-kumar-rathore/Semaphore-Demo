class AddReferences < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_types, :organization, foreign_key: true
  end
end
