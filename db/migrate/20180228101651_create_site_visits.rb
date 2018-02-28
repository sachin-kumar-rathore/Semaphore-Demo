class CreateSiteVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :site_visits do |t|
      t.integer       :project_id
      t.date          :visit_date

      t.timestamps
    end
  end
end
