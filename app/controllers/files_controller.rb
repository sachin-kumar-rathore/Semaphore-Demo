class FilesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_file, only: [:edit, :update, :destroy, :show_projects, :attach_project_to_file]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @files = current_org.documents.paginate(page: params[:page], per_page: 10).order('updated_at DESC')
  end

  def new
    @file = current_org.documents.new
  end

  def create
    @file = current_org.documents.create(file_params)
    if @file.save
      flash.now[:success] = "File successfully saved."
    else
      flash.now[:danger] = "File could not be created."
    end
  end

  def edit
  end

  def update
    if @file.update(file_params)
      flash.now[:success] = "File successfully updated."
    else
      flash.now[:danger] = "File could not be updated."
    end
  end

  def destroy
    if @file.destroy
      flash.now[:success] = "File successfully deleted."
    else
      flash.now[:danger] = "File could not be deleted."
    end
  end

  def show_projects
    @projects = current_org.projects
  end

  def attach_project_to_file
    @project = params[:project_id].present? ? current_org.projects.where(id: params[:project_id]).first : nil
    @file.project = @project
    if @file.save && @project
      flash.now[:success] = "Successfully attached project to file. "
    else
      flash.now[:danger] = "No project attached to file."
    end
  end

  private

  def set_file
    @file = current_org.documents.where(id: params[:id]).first
  end

  def file_params
    params.require(:document).permit(:name, :project_id).merge(user_id: current_user.id)
  end

end