class ProjectFilesController < FilesController

  before_action :set_project

  def index
    @files = @project.documents.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
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
