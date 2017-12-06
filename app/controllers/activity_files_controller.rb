class ActivityFilesController < FilesController

  before_action :set_activity
  respond_to :js

  def index
    @files = @activity.documents.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
    redirect_to edit_activity_path(@activity) if request.format.html?
  end

  private

  def set_activity
    @activity = current_org.activities.where(id: params[:activity_id]).first
  end

  def file_params
    params.require(:document).permit(:name, :documentable_id).merge(user_id: current_user.id, documentable_type: "Activity")
  end

end
