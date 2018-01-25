class RemoveTitleAndCompanyOrganizationNameFromCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :title, :string
    remove_column :companies, :company_organization_name, :string
  end
end
