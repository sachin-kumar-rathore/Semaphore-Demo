class ActivitiesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_activity, only: [:edit, :update, :destroy]

  def index
    @activities = current_org.activities
    @activities = @activities.where(company_id: params[:company_id]) if params[:company_id].present?
    @activities = @activities.paginate(page: params[:page], per_page: 8)
  end

  def new
    @activity = current_org.activities.new
  end

  def edit
    
  end

  def create
    @activity = current_org.activities.new(activity_params)
    if @activity.save
      if params[:commit] == "Save & Close"
        flash[:success] = 'Activity was successfully created.'
        redirect_to activities_path
      else
        flash[:success] = 'Activity was successfully saved.'
        redirect_to edit_activity_path(@activity)
      end 
    else
      flash[:danger] = 'Activity could not be created.'
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      if params[:commit] == "Save & Close"
        flash[:success] = 'Activity was successfully updated.'
        redirect_to activities_path
      else
        flash[:success] = 'Activity was successfully updated.'
        redirect_to edit_activity_path(@activity)
      end 
    else
      flash[:danger] = 'Activity could not be updated.'
      render :edit
    end
  end

  def destroy
    if @activity.destroy
      flash[:success] = "Activity deleted successfully."
    else
      flash[:danger] = "Could not delete activity."
    end
    redirect_to activities_path
  end

  def check_activities_number_validity
    set_message_and_status_for_id_validity("activities")
  end

  private

  def activity_params
    params.require(:activity).permit(:company_activity_type_id, :name, :activity_number, :provided_service_id,
                                     :contact_date_str, :contact_method_type_id, :primary_contact_id, :assigned_user,
                                     :description, :follow_up_date_str, :company_id)
  end

  def set_activity
    @activity = current_org.activities.where(id: params[:id]).first
    if @activity.blank?
      flash[:danger] = "Activity not found."
      redirect_to activities_path
    end
  end

end
