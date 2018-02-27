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
      site_visit_1: 'Site Visit 1',
      site_visit_2: 'Site Visit 2',
      site_visit_3: 'Site Visit 3',
      site_selector: 'Site Selector',
      utilize_sites: 'Sites and Building Database Utilized',
      speculative_building: 'Speculative Building',
      located: 'Located',
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
    current_org.project_managers.map { |user| [(user.first_name + ' ' + user.last_name), user.id] }
  end

  def assign_default_project_number
    project_numbers = Project.pluck(:project_number)
    while(true)
      project_no = rand.to_s[2..7]
      unless project_numbers.include?(project_no)
        return project_no
      end
    end
  end
end