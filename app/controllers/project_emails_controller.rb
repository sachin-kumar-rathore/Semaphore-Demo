class ProjectEmailsController < EmailsController

  before_action :set_project
  respond_to :js
  
  def index
    @emails = @project.emails.includes(:contacts)
    filtering_params(params).each do |key, value|
      @emails = @emails.public_send(key, value) if value.present?
    end
    @emails = @emails.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
    redirect_to edit_project_path(@project) if request.format.html?
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

end
