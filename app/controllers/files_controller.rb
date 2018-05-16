# Manage files belonging to an organization
class FilesController < ManageGeneralModulesController
  before_action :authenticate_user!, :authorized_module?
  before_action :authorized_user_to_write?, except: %i[index]
  before_action :set_file, only: %i[edit update destroy show_projects
                                    attach_project_to_file]
  respond_to :html, only: %i[index]
  respond_to :js

  def index
    @files = current_org.documents.without_activity
    @files= @files.where('id = ?', params[:id]) if params[:id].present?
    
    if params[:project_id].present?
      @files = @files
               .where('documentable_id = ? AND documentable_type = ?',
                      params[:project_id], 'Project')
    end

    @files = @files.filter_by_doc_type(params[:file_type]) if params[:file_type].present?
    
    @files = @files.paginate(page: params[:page], per_page: 10)
                   .order('updated_at DESC')
  end

  def new
    @file = current_org.documents.new
  end

  def create
    @file = current_org.documents.create(file_params)
    if @file.save
      flash.now[:success] = 'File successfully saved.'
    else
      flash.now[:danger] = 'File could not be created.'
    end
  end

  def edit; end

  def update
    if @file.update(file_params)
      flash.now[:success] = 'File successfully updated.'
    else
      flash.now[:danger] = 'File could not be updated.'
    end
  end

  def destroy
    if @file.destroy
      flash.now[:success] = 'File successfully deleted.'
    else
      flash.now[:danger] = 'File could not be deleted.'
    end
  end

  def show_projects
    @projects = current_org.projects
  end

  def attach_project_to_file
    @project = assign_project
    @file.documentable_type = 'Project'
    @file.documentable_id = @project.id
    if @file.save && @project
      flash.now[:success] = 'Successfully attached project to file. '
    else
      flash.now[:danger] = 'No project attached to file.'
    end
  end

  private

  def set_file
    @file = current_org.documents.where(id: params[:id]).first
  end

  def file_params
    params.require(:document).permit(:name, :documentable_id)
          .merge(user_id: current_user.id, documentable_type: 'Project')
  end

  def assign_project
    return nil unless params[:project_id].present?
    current_org.projects.where(id: params[:project_id]).first
  end
end
