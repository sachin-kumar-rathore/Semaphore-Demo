class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :status
      t.string :project_type
      t.string :source
      t.integer :primary_contact_id
      t.string :industry_type
      t.string :business_unit
      t.text :description
      t.date :active_date
      t.date :successful_completion_date
      t.string :business_type
      t.string :square_feet_requested
      t.text :square_footage_note
      t.string :acres_requested
      t.text :acreage_note
      t.string :new_jobs
      t.text :new_jobs_notes
      t.decimal :wages
      t.text :wages_notes
      t.decimal :net_new_investment
      t.text :net_new_investment_notes
      t.date :public_release_date
      t.boolean :public_release
      t.boolean :site_selector
      t.boolean :utilize_sites
      t.boolean :speculative_building
      t.string :elimination_reason
      t.string :located
      t.string :unique_id
      t.string :retained_jobs
      t.date :site_visit_1
      t.date :site_visit_2
      t.date :site_visit_3

      t.timestamps
    end
  end
end
