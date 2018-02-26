module ExportsHelper

  def get_field_value(project, field)
    associated_fields = ['project_type', 'industry_type', 'company', 'elimination_reason', 'incentive', 'competition', 'source']
    boolen_fields = ['site_selector', 'utilize_sites', 'speculative_building', 'public_release']
    
    if field.to_s == 'contact'
      contacts = []
      contacts[0] = project.primary_contact.try(:name)
      contacts << project.contacts.pluck(:name)
      contacts.flatten.join(', ')

    elsif field.to_s == 'considered_location' 
      project.send(field).try(:location)

    elsif field.to_s == 'site_visits' 
      project.send(field).pluck(:visit_date).join(', ')

    elsif field.to_s == 'project_manager'
      project.send(field).try(:full_name)

    elsif associated_fields.include?(field.to_s)
      project.send(field).try(:name)
    
    elsif boolen_fields.include?(field.to_s)
      project.send(field) ? 'Y' : 'N'
      
    else
      project.send(field)
    end
  end

  def get_company_field_value(company, field)
    associated_fields = ['project_type', 'industry_type']
    boolen_fields = ['room_for_expansion', 'business_union_represented', 'member_investor']
    
    if associated_fields.include?(field.to_s)
      company.send(field).try(:name)
    
    elsif boolen_fields.include?(field.to_s)
      company.send(field) ? 'Yes' : 'No'
      
    else
      company.send(field)
    end
  end

  def get_contact_field_value(contact, field)
    associated_fields = ['contact_category', 'organization']

    if associated_fields.include?(field.to_s)
      contact.send(field).try(:name)
    else
      contact.send(field)
    end
  end
end