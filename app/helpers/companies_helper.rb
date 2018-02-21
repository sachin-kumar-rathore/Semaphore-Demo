module CompaniesHelper
  def company_export_options
    {  
      name: 'Company Name',
      company_number: 'Company Number',
      industry_type: 'Industry Type',
      address_line_1: 'Street Address 1',
      address_line_2: 'Street Address 2',
      city: 'City',
      state: 'State',
      zip_code: 'Zip Code',
      country: 'Country',
      region: 'Region',
      cell_phone: 'Telephone',
      fax: 'Fax',
      website: 'Website',
      email: 'Email',
      member_investor: 'Member Investor',
      utility_provider_1: 'Utility Provider 1',
      utility_provider_2: 'Utility Provider 2',
      notes: 'Company Notes',
      business_unit: 'Business Unit',
      years_business_located: 'Years Business Located in Community',
      company_establishment_year: 'Years Company Established in Community',
      project_type: 'Type of Facility',
      acreage: 'Acreage',
      building_size: 'Building Size',
      number_of: 'Number of Buildings',
      average_age_of_buildings: 'Average Age of Buildings',
      room_for_expansion: 'Is there Room for Expansion at this location',
      owned_or_leased: 'Owned or Leased',
      lease_expiration_date: 'Lease Expiration Date',
      owner: 'Property Owner',
      facility_notes: 'Facility Notes',
      primary_products_and_services: 'Primary Products',
      naics_code_1: 'NAICS Code 1',
      naics_code_2: 'NAICS Code 2',
      naics_code_3: 'NAICS Code 3',
      naics_code_4: 'NAICS Code 4',
      naics_code_5: 'NAICS Code 5',
      full_time_employees: 'Full-Time Employees',
      part_time_employees: 'Part-Time Employees',
      leased_employees: 'Leased Employees',
      total_employees: 'Total Employees',
      date_of_total: 'Date of Total',
      number_of_jobs_added_or_lost_in_past_3_years: 'Number of Jobs Added/Lost in past 3 yrs',
      number_of_shifts_per_day: 'Number of shifts per day',
      number_of_days_per_week: 'Number of Days per Week',
      peak_season: 'Peak Season',
      average_annual_salary: 'Average Annual Wage/Salary',
      employment_notes: 'Employment Notes',
      business_union_represented: 'Business Union Represented',
      union_notes: 'Union Notes'
    }
  end

  def get_company_field_value(company, field)
    associated_fields = ['project_type', 'industry_type', 'business_unit']
    boolen_fields = ['room_for_expansion', 'business_union_represented', 'member_investor']
    
    if field.to_s.split('_').first == 'naics'
      company.naics_codes

    elsif associated_fields.include?(field.to_s)
      company.send(field).try(:name)
    
    elsif boolen_fields.include?(field.to_s)
      company.send(field) ? 'Yes' : 'No'
      
    else
      company.send(field)
    end
  end
end