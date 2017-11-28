class AddReferencesInCompany < ActiveRecord::Migration[5.1]

  def change
    add_reference :companies, :organization, foreign_key: true
    add_column :companies, :title, :string
    add_column :companies, :phone_number_1, :string
    add_column :companies, :phone_number_2, :string
    add_column :companies, :cell_phone, :string
    add_column :companies, :fax, :string
    add_column :companies, :region, :string
    rename_column :companies, :utility_provider, :utility_provider_1
    add_column :companies, :utility_provider_2, :string
    add_column :companies, :facility_type, :string
    add_column :companies, :acreage, :string
    add_column :companies, :building_size, :string
    add_column :companies, :number_of, :string
    add_column :companies, :average_age_of_buildings, :string
    add_column :companies, :room_for_expansion, :boolean
    add_column :companies, :owned_or_leased, :string
    add_column :companies, :lease_expiration_date, :date
    add_column :companies, :facility_notes, :text
    add_column :companies, :primary_products_and_services, :text
    add_column :companies, :full_time_employees, :integer
    add_column :companies, :part_time_employees, :integer
    add_column :companies, :leased_employees, :integer
    add_column :companies, :total_employees, :integer
    add_column :companies, :number_of_jobs_added_or_lost_in_past_3_years, :integer
    add_column :companies, :number_of_shifts_per_day, :integer
    add_column :companies, :number_of_days_per_week, :integer
    add_column :companies, :average_annual_salary, :string
    add_column :companies, :date_of_total, :date
    add_column :companies, :employment_notes, :text
    add_column :companies, :business_union_represented, :boolean
  end

end
