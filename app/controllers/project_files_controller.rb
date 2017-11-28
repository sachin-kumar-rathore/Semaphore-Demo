class ProjectFilesController < FilesController

  before_action :set_project
  respond_to :js

  def index
    @files = @project.documents.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
    redirect_to edit_project_path(@project) if request.format.html?
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

end
