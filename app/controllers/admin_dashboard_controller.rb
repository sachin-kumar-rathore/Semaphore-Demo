# Manage dashboard for super admin user
class AdminDashboardController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    @organizations = Organization.all
                                 .paginate(page: params[:page], per_page: 8)
  end

  def sign_in_as_org_user
    return unless current_admin
    org = Organization.where(id: params[:id]).first
    @user = org.users.with_role :admin
    if org && @user
      bypass_sign_in @user.first, scope: :user
      redirect_to dashboard_index_path
    else
      flash[:danger] = 'Unable to login as admin. Please try again.'
      redirect_to admin_dashboard_index_path
    end
  end
end
