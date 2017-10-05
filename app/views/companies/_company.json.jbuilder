json.extract! company, :id, :owner_id, :subscription_id, :name, :company_number, :business_sector, :address_line_1, :address_line_2, :city, :state, :zip_code, :country, :website, :email, :member_investor, :utility_provider, :notes, :business_unit, :company_establishment_year, :years_business_located, :created_at, :updated_at
json.url company_url(company, format: :json)
