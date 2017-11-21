class ProjectTasksController < TasksController

  before_action :set_project
  respond_to :js

  def index
    @tasks = @project.tasks.paginate(page: params[:page], per_page: 8)
    redirect_to edit_project_path(@project) if request.format.html?
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

end
