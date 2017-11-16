class ProjectEmailsController < EmailsController

  before_action :set_project

  def index
    @emails = @project.emails.includes(:contacts)
    filtering_params(params).each do |key, value|
      @emails = @emails.public_send(key, value) if value.present?
    end
    @emails = @emails.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
    respond_to do |format|
      format.js
      format.html { redirect_to edit_project_path(@project) }
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

end
