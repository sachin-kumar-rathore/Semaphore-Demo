class AddCompanyOrganizationNameToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :company_organization_name, :string
  end
end
