class ChangeColumnsInCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :peak_season, :string
    add_column :companies, :union_notes, :text
    rename_column :companies, :business_sector, :industry_type
  end
end
