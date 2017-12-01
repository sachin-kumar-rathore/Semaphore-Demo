class AddReferencesForSettingFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :category
    remove_column :contacts, :business_unit
    remove_column :sites, :business_unit
    remove_column :companies, :industry_type
    remove_column :companies, :business_unit
    remove_column :companies, :facility_type
    remove_column :projects, :project_type
    remove_column :projects, :industry_type
    remove_column :projects, :business_unit
    remove_column :projects, :considered_location
    remove_column :projects, :competition
    remove_column :projects, :provided_service
    remove_column :projects, :source
    remove_column :projects, :elimination_reason
    add_column :companies, :naics_codes, :string
    add_reference :contacts, :contact_category, foreign_key: true 
    add_reference :contacts, :business_unit, foreign_key: true
    add_reference :sites, :business_unit, foreign_key: true
    add_reference :companies, :industry_type, foreign_key: true
    add_reference :companies, :business_unit, foreign_key: true
    add_reference :companies, :project_type, foreign_key: true
    add_reference :projects, :project_type, foreign_key: true
    add_reference :projects, :industry_type, foreign_key: true
    add_reference :projects, :business_unit, foreign_key: true
    add_reference :projects, :considered_location, foreign_key: true
    add_reference :projects, :competition, foreign_key: true
    add_reference :projects, :provided_service, foreign_key: true
    add_reference :projects, :source, foreign_key: true
    add_reference :projects, :elimination_reason, foreign_key: true   
  end
end
