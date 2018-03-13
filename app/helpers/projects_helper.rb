module ProjectsHelper
  def export_options
    {  
      project_number: 'Project Id#',
      name: 'Project Name',
      company: 'Company Name',
      project_manager: 'Project Manager',
      status: 'Status',
      elimination_reason: 'Elimination Reason',
      active_date: 'Active Date',
      contact: 'Contact',
      business_type: 'Business Type',
      project_type: 'Project Type',
      industry_type: 'Industry Type',
      description: 'Project Description',
      square_feet_requested: 'Square Feet Requested',
      square_footage_note: 'Square Footage Notes',
      #real_estate_requested: 'Real Estate Requested',
      acres_requested: 'Acres Requested',
      acreage_note: 'Acreage Notes',
      new_jobs: 'New Jobs',
      retained_jobs: 'Retained Jobs',
      new_jobs_notes: 'New Jobs Notes',
      wages: 'Wages',
      wages_notes: 'Wages Notes',
      net_new_investment: 'Net New Investment',
      net_new_investment_notes: 'New Investment Notes',
      considered_location: 'Considered Locations',
      incentive: 'Incentives',
      competition: 'Competition',
      source: 'Source',
      site_visits: 'Site Visits',
      site_selector: 'Site Selector',
      utilize_sites: 'Sites and Building Database Utilized',
      speculative_building: 'Speculative Building',
      where_located: 'Located',
      public_release: 'Public Release',
      public_release_date: 'Public Release Date',
      successful_completion_date: 'Completion Date'
    }
  end

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
      pr_manager = project.send(field)
      pr_manager.try(:first_name).to_s + ' ' + pr_manager.try(:last_name).to_s

    elsif associated_fields.include?(field.to_s)
      project.send(field).try(:name)
    
    elsif boolen_fields.include?(field.to_s)
      project.send(field) ? 'Y' : 'N'
      
    else
      project.send(field)
    end
  end

  def load_project_manager_data_with_id
    current_org.project_managers.map { |user| [user.full_name, user.id] }
  end

  def audit_description(audit)
    project = (audit.auditable_type == 'Project') ? audit.auditable : audit.associated
    action = (audit.action == 'destroy') ? 'deleted' : "#{audit.action}d"
    return "#{(audit.auditable_type == 'Project') ? 'The main record' : object_description(audit)} for #{project.name}, Project #{project.project_number} is #{action}"
  end

  def object_description(audit)
    case audit.auditable_type
    when 'Task' then "Task #{audit.auditable.try(:name)}"
    when 'ProjectSite' then "Site/Building referral #{audit.auditable.try(:site).try(:site_number)} | #{audit.auditable.try(:site).try(:name)}"
    when 'Site' then "Site/Building referral #{audit.auditable.try(:site_number)} | #{audit.auditable.try(:name)}"
    when 'ProjectContact' then "Contact #{audit.auditable.try(:contact).try(:name)}"
    when 'Contact' then "Contact #{audit.auditable.try(:name)}"
    when 'Note' then "Note #{audit.auditable.try(:subject)}"
    when 'Document' then "File #{File.basename(audit.auditable.name.path) if audit.auditable}"
    when 'Email' then "Email #{audit.auditable.try(:subject)}"
    end
  end

  def load_company_data_with_id(companies)
    [['Quick add company', 'Other']] + load_data_with_id(companies)
  end
end