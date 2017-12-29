class ActivityEmailsController < EmailsController

  before_action :set_activity
  respond_to :js
  
  def index
    @emails = @activity.emails.includes(:contacts)
    filtering_params(params).each do |key, value|
      @emails = @emails.public_send(key, value) if value.present?
    end
    @emails = @emails.paginate(page: params[:page], per_page: 8).order('emails.updated_at DESC')
    redirect_to edit_activity_path(@activity) if request.format.html?
  end

  private

  def set_activity
    @activity = current_org.activities.where(id: params[:activity_id]).first
  end

end
