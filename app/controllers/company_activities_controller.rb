# Manage acitivites associated with a particular company
class CompanyActivitiesController < ActivitiesController
  before_action :set_company, :authorize_current_controller
  respond_to :js

  def new
    @activity = @company.activities.new
  end

  private

  def set_company
    @company = current_org.companies.where(id: params[:company_id]).first
  end

  def redirect_after_commit
    if params[:commit] == 'Save & Close'
      redirect_to edit_company_path(@company) + '#activities'
    else
      redirect_to edit_company_activity_path(@company, @activity)
    end
  end

  def authorize_current_controller
    match_enabled_module('activities')
  end
end
