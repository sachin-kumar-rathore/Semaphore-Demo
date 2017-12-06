class AddFieldsToActivity < ActiveRecord::Migration[5.1]
  def change
    add_reference :activities, :company_activity_type, foreign_key: true
    add_reference :activities, :company, foreign_key: true
    add_reference :activities, :provided_service, foreign_key: true
    add_reference :activities, :contact_method_type, foreign_key: true
    add_column :activities, :name, :string
    add_column :activities, :activity_number, :string
    add_column :activities, :contact_date, :date
    add_column :activities, :primary_contact_id, :integer
    add_column :activities, :assigned_user, :integer
    add_column :activities, :description, :text
    add_column :activities, :follow_up_date, :date
    add_reference :activities, :organization, foreign_key: true
  end
end
