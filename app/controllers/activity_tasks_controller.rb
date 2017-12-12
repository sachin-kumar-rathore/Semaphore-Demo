class ActivityTasksController < TasksController

  before_action :set_activity
  respond_to :js

  def index
    @tasks = @activity.tasks.paginate(page: params[:page], per_page: 8)
    redirect_to edit_activity_path(@activity) if request.format.html?
  end

  private

  def set_activity
    @activity = current_org.activities.where(id: params[:activity_id]).first
  end

  def task_params
    params.require(:task).permit(:name, :description, :start_date_str, :end_date_str, :status,
                                 :priority, :progress,:assignee_id, :taskable_id).merge(taskable_type: "Activity")
  end
end
