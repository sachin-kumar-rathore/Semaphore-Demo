# Manage organizations
class OrganizationsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_organization, except: %i[index]
  layout 'admin'

  def index
    @organizations = Organization.all
                                 .paginate(page: params[:page], per_page: 8)
  end

  def edit; end

  def show
    redirect_to edit_organization_path(@organization)
  end

  def update
    @organization.update(organization_params)
  end

  def sign_in_as_admin
    @user = @organization.users.with_role :admin
    bypass_sign_in_with_user
  end

  def sign_in_as_user
    @user = @organization.users.where(id: params[:user_id])
    bypass_sign_in_with_user
  end

  private

  def set_organization
    @organization = Organization.where(id: params[:id]).first
    return unless @organization.blank?
    flash[:danger] = 'Organization not found.'
    redirect_to organizations_path
  end

  def organization_params
    params.require(:organization).permit(:name, :url,
                                         :primary_contact_first_name,
                                         :primary_contact_last_name,
                                         :primary_contact_phone,
                                         :primary_contact_email)
  end

  def bypass_sign_in_with_user
    if @organization && @user
      bypass_sign_in @user.first, scope: :user
      redirect_to dashboard_index_path
    else
      flash[:danger] = 'Unable to login as user. Please try again.'
      redirect_to organizations_path
    end
  end
end
