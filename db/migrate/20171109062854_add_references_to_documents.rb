class AddReferencesToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_reference :documents, :organization, foreign_key: true
    add_reference :documents, :project, foreign_key: true
    add_reference :documents, :user, foreign_key: true
  end
end
