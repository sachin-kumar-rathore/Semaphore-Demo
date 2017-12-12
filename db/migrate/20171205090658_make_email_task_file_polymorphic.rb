class MakeEmailTaskFilePolymorphic < ActiveRecord::Migration[5.1]
  def change
    remove_reference :documents, :project
    remove_reference :documents, :activity
    add_reference :documents, :documentable, polymorphic: true
    remove_reference :tasks, :project
    remove_reference :tasks, :activity
    add_reference :tasks, :taskable, polymorphic: true
    remove_column :emails, :project_id
    remove_reference :emails, :activity
    add_reference :emails, :mailable, polymorphic: true
  end
end
