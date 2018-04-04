crumb :root do
  link "Home", dashboard_index_path
end

# tasks breadcrumbs
crumb :tasks do
  link 'Tasks', tasks_path
end


# emails breadcrumbs
crumb :emails do
  link 'Mailbox', emails_path
end


# activities breadcrumbs
crumb :activities do
  link "Activities", activities_path
end

crumb :activity do |activity|
  link activity.name, edit_activity_path(activity)
  parent :activities
end


# contacts breadcrumbs
crumb :contacts do
  link 'Contacts', contacts_path
end


# projects breadcrumbs
crumb :projects do
  link "Projects", projects_path
end

crumb :project do |project|
  link project.name, project_path(project)
  parent :projects
end


# companies breadcrumbs
crumb :companies do
  link "Companies", companies_path
end

crumb :company do |company|
  link company.name, edit_company_path(company)
  parent :companies
end

crumb :company_activities do |company|
  link "Activities", edit_company_path(company) + '#activities'
  parent :company, company
end


crumb :company_activity do |activity|
  link activity.name, edit_company_activity_path(activity.company, activity)
  parent :company_activities, activity.company
end


# sites/buildings breadcrumbs
crumb :sites do
  link 'Sites & Buildings', sites_path
end

# reports breadcrumbs
crumb :reports do
  link 'Reports', reports_path
end

crumb :reports_projects do
  link 'Successful Project Data', projects_reports_path
  parent :reports
end

crumb :reports_sites do
  link 'Site & Building Referrals', sites_reports_path
  parent :reports
end

crumb :yearly_reports do
  link 'Yearly Activity', yearly_reports_path
  parent :reports
end

crumb :monthly_reports do
  link 'Monthly Activity', monthly_reports_path
  parent :reports
end


# files breadcrumbs
crumb :files do
  link 'Files', files_path
end


# imports breadcrumbs
crumb :imports do
  link 'Imports', imports_path
end

# exports breadcrumbs
crumb :exports do
  link 'Exports', exports_path
end

crumb :project_exports do
  link 'Projects Export', export_form_projects_path
  parent :exports
end

crumb :companies_exports do
  link 'Companies Export', export_form_companies_path
  parent :exports
end


# Settings breadcrumbs
crumb :settings do
  link 'Settings'
end

crumb :manage_users do
  link 'Manage Users', manage_users_path
  parent :settings
end

crumb :manage_configurations do
  link 'Manage configurations', manage_configurations_path
  parent :settings
end

crumb :considered_locations do
  link 'Considered Loactions', considered_locations_path
  parent :settings
end

crumb :security_roles do
  link 'Manage Roles', security_roles_path
  parent :settings
end

crumb :project_logs do
  link 'Project Logs', project_logs_path
  parent :settings
end

crumb :organization_details do
  link 'Organization Details', organization_details_path
  parent :settings
end