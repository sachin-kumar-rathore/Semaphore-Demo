class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:show, :new]

  def index
    @tasks = current_org.tasks
    @tasks = params[:assigned_to_me] == "true" ? current_user.assigned_tasks : current_user.tasks if params[:current_user_filter] == "true"
    @tasks = @tasks.where(project_id: params[:project_id]) if params[:project_id].present?
    @tasks = @tasks.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def new
    @task = current_user.tasks.new
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)
    respond_to do |format|
      if @task.save
        flash.now[:success] = 'Task was successfully created.'
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        flash.now[:success] = 'Task was successfully updated.'
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @task.destroy
        flash.now[:success] = 'Task was successfully destroyed.'
      else
        flash.now[:info] = 'Task could not be destroyed.'
      end
      format.js
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
