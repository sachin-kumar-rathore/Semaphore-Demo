module ProjectsHelper

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
    when 'Document' then "File #{audit.auditable.file_name || File.basename(audit.auditable.name.path) if audit.auditable}"
    when 'Email' then "Email #{audit.auditable.try(:subject)}"
    end
  end

  def load_company_data_with_id(companies)
    current_user.can_write?('companies') ? [['Quick add company', 0 ]] + load_data_with_id(companies)
                                         : load_data_with_id(companies)
  end
end