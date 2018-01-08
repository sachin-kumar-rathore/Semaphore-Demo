# Manage Users in an Organization by admin
class ManageUsersController < ApplicationController
  before_action :authenticate_admin!, only: %i[edit update]
  before_action :authenticate_user!, except: %i[edit update]
  before_action :set_org_and_user, only: %i[edit update]
  before_action :set_user, only: %i[edit_invitation update_invitation destroy]
  respond_to :js
  respond_to :html, only: [:index]

  def index
    @users = current_org.users.includes(:user_roles)
    filtering_params(params).each do |key, value|
      @users = @users.public_send(key, value) if value.present?
    end
    @users = @users.paginate(page: params[:page],
                             per_page: User::PAGINATION_VALUE)
                   .order('updated_at DESC')
  end

  def new
    @user = current_org.users.new
  end

  def edit_invitation; end

  def update_invitation
    return unless @user.update(invite_user_params)
    @user.deliver_invitation if should_invite_user
    flash.now[:success] = 'User was successfully updated.'
    load_users
  end

  def create
    @user = User.invite!(invite_user_params) do |u|
      u.skip_invitation = !u.active
    end
    flash.now[:success] = 'User was successfully created.' if @user.persisted?
    load_users
  end

  def edit; end

  def update
    if params[:password].blank? && params[:password_confirmation].blank?
      @user.update(update_params_without_password)
    else
      @user.update(update_params)
    end
  end

  def destroy
    return unless @user.destroy
    flash.now[:success] = 'User successfully deleted.'
    load_users
  end

  private

  def update_params
    params.require(:user).permit(:first_name, :last_name,
                                 :password, :password_confirmation)
  end

  def update_params_without_password
    params.require(:user).permit(:first_name, :last_name)
  end

  def set_user
    @user = current_org.users.where(id: params[:id]).first
  end

  def set_org_and_user
    @organization = Organization.where(id: params[:organization_id]).first
    @user = @organization.users.where(id: params[:id]).first
  end

  def invite_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :active,
                                 security_role_ids: [])
          .merge(organization_id: current_org.id)
  end

  def load_users
    @users = current_org.users.all_except(current_user)
                        .paginate(page: params[:page],
                                  per_page: User::PAGINATION_VALUE)
                        .order('updated_at DESC')
  end

  def should_invite_user
    !@user.invitation_sent_at? && @user.active || params[:resend_invite]
  end

  def filtering_params(params)
    params.slice(:first_name, :last_name, :user_role)
  end
end
