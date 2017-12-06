class AddReferencesInTaksEmailsFiles < ActiveRecord::Migration[5.1]
  def change
    add_reference :tasks, :activity, foreign_key: true
    add_reference :emails, :activity, foreign_key: true
    add_reference :documents, :activity, foreign_key: true
  end
end
