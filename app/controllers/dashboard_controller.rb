# Manage dashboard for org users
class DashboardController < ApplicationController
  before_action :authenticate_user!

  include DashboardModule

  def index
    @projects = current_org.projects
    @project_status_group = @projects.status({'1': 'Active', '2': 'Preliminary'}).group_by { |p| p.status }
    generate_periodic_report('yearly')
    @tasks = current_org.tasks.without_activity.limit(5).sort_by {|task| [task.priority, task.end_date]}
  end

  def tasks
    @tasks = filter_tasks_by_assigner
    @tasks = filter_tasks_by_project
    @tasks = @tasks.limit(5).sort_by {|task| [task.priority, task.end_date]}
    respond_to do |format|
      format.js
    end
  end

  def authenticate_user!
    if current_admin.present? && current_user.blank?
      redirect_to organizations_path
    elsif !current_user.present?
      redirect_to new_user_session_path
    end
  end

  private

  def filter_tasks_by_assigner
    if params[:filter] == 'my_tasks'
      current_user.assigned_tasks.without_activity
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