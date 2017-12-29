# Manage tasks belonging to an organization
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_users, only: %i[show new]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @tasks = filter_tasks_by_user
    @tasks = filter_tasks_by_project
    @tasks = @tasks.paginate(page: params[:page], per_page: 8)
  end

  def show; end

  def new
    @task = current_user.tasks.new
  end

  def edit; end

  def create
    @task = current_user.tasks.new(task_params)
    flash.now[:success] = 'Task was successfully created.' if @task.save
  end

  def update
    return unless @task.update(task_params)
    flash.now[:success] = 'Task was successfully updated.'
  end

  def destroy
    if @task.destroy
      flash.now[:success] = 'Task was successfully destroyed.'
    else
      flash.now[:danger] = 'Task could not be destroyed.'
    end
  end

  private

  def set_task
    @task = current_org.tasks.where(id: params[:id]).first
  end

  def task_params
    params.require(:task).permit(:name, :description, :start_date_str,
                                 :end_date_str, :status, :priority, :progress,
                                 :assignee_id, :taskable_id)
          .merge(taskable_type: 'Project')
  end

  def set_users
    @users = current_org.users
  end

  def filter_tasks_by_user
    if params[:assigned_to_me] == 'true'
      current_user.assigned_tasks.without_activity
    elsif params[:current_user_filter] == 'true'
      current_user.tasks.without_activity
    else
      current_org.tasks.without_activity
    end
  end

  def filter_tasks_by_project
    return @tasks unless params[:project_id].present?
    @tasks = @tasks.where('taskable_id = ? AND taskable_type = ? ',
                          params[:project_id], 'Project')
  end
end
