class CreateProjectContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :project_contacts do |t|

      t.timestamps
    end
  end
end
