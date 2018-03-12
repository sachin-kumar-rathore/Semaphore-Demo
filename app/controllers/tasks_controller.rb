# Manage tasks belonging to an organization
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_users, only: %i[show new]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @tasks = filter_tasks_by_user
    @tasks = filter_tasks_by_project_or_search_result
    @tasks = filter_tasks_by_status
    @tasks = @tasks.paginate(page: params[:page], per_page: Task::PAGINATION_VALUE)
                   .order('updated_at DESC')
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
    if params[:current_user_filter] == 'true'
      if params[:assigned_to_me] == 'true'
        current_user.assigned_tasks.without_activity
      else
        current_user.tasks.without_activity
      end
    else
      current_org.tasks.without_activity
    end
  end

  def filter_tasks_by_project_or_search_result
    if params[:project_id].present?
      @tasks.where('taskable_id = ? AND taskable_type = ? ',
                          params[:project_id], 'Project')
    elsif params[:id].present?
      @tasks.where(id: params[:id])
    else
      @tasks
    end
  end

  def filter_tasks_by_status
    if params[:status].present?
      (params[:status] == 'All') ? @tasks : @tasks.filter_by_status(params[:status])
    else
      @tasks.filter_by_status('In-Progress')
    end
  end
end
