module DashboardModule
  include ReportingModule

  def predefined_parameters
    %w(status project_type_id industry_type_id)
  end
end