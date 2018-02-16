json.extract! site, :id, :organization_id, :site_number, :name, :type, :address_line, :city, :state, :zip_code, :country, :available_acreage, :available_square_feet, :tota_acreage, :total_square_feet, :latitude, :longitude, :created_at, :updated_at
json.url site_url(site, format: :json)
