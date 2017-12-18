# Manage dashboard for org users
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def authenticate_user!
    if current_admin.present? && current_user.blank?
      redirect_to admin_dashboard_index_path
    elsif !current_user.present?
      redirect_to new_user_session_path
    end
  end
end
