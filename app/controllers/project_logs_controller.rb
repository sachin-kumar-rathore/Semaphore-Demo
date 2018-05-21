class ProjectLogsController < ManageGeneralModulesController
  before_action :authenticate_user!, :authorize_controller
  
  def index
    @projects = current_org.projects
    filtering_params(params).each do |key, value|
      @projects = @projects.public_send(key, value) if value.present?
    end
    @projects = @projects.includes(:audits, :associated_audits)
    @project_logs = @projects.collect { |project| project.audits + project.associated_audits }.flatten.sort.reverse
                    .paginate(page: params[:page], per_page: 8)
  end

  private

  def filtering_params(params)
    params.slice(:start_date, :project_name, :company, :project_manager_id)
  end

  def authorize_controller
    match_enabled_module('projects')
  end
end
