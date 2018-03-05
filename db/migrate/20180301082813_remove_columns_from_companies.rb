class RemoveColumnsFromCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :utility_provider_1, :string
    remove_column :companies, :utility_provider_2, :string
    remove_column :companies, :business_unit_id, :bigint
  end
end
