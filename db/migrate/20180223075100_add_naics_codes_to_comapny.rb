class AddNaicsCodesToComapny < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :naics_codes
    add_column :companies, :naics_code_1, :string
    add_column :companies, :naics_code_2, :string
    add_column :companies, :naics_code_3, :string
    add_column :companies, :naics_code_4, :string
    add_column :companies, :naics_code_5, :string
  end
end
