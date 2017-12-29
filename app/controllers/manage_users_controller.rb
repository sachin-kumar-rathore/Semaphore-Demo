# Manage Users in an Organization by admin
class ManageUsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_org_and_user
  respond_to :js

  def edit; end

  def update
    if params[:password].blank? && params[:password_confirmation].blank?
      @user.update(update_params_without_password)
    else
      @user.update(update_params)
    end
  end

  private

  def update_params
    params.require(:user).permit(:first_name, :last_name,
                                 :password, :password_confirmation)
  end

  def update_params_without_password
    params.require(:user).permit(:first_name, :last_name)
  end

  def set_org_and_user
    @organization = Organization.where(id: params[:organization_id]).first
    @user = @organization.users.where(id: params[:id]).first
  end
end
