class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:show, :new]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @tasks = current_org.tasks
    @tasks = params[:assigned_to_me] == "true" ? current_user.assigned_tasks : current_user.tasks if params[:current_user_filter] == "true"
    @tasks = @tasks.where(project_id: params[:project_id]) if params[:project_id].present?
    @tasks = @tasks.paginate(page: params[:page], per_page: 8)
  end

  def show
  end

  def new
    @task = current_user.tasks.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash.now[:success] = 'Task was successfully created.'
    end
  end

  def update
    if @task.update(task_params)
      flash.now[:success] = 'Task was successfully updated.'
    end
  end

  def destroy
    if @task.destroy
      flash.now[:success] = 'Task was successfully destroyed.'
    else
      flash.now[:danger] = 'Task could not be destroyed.'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = current_org.tasks.where(id: params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description, :start_date_str, :end_date_str, :status,
                                 :priority, :progress,:assignee_id, :project_id)
  end

  def set_users
    @users = current_org.users
  end

end
