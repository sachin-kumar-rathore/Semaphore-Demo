class AddProjectAndContactToProjectContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_contacts, :project, foreign_key: true
    add_reference :project_contacts, :contact, foreign_key: true
  end
end
