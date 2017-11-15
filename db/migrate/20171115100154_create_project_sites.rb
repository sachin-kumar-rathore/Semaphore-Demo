class CreateProjectSites < ActiveRecord::Migration[5.1]
  def change
    create_table :project_sites do |t|

      t.timestamps
    end
  end
end
