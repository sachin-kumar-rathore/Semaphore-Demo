# Manage organizations
class OrganizationsController < ApplicationController
  before_action :authenticate_admin!, except: %i[edit_details update]
  before_action :set_organization, except: %i[index edit_details]
  before_action :load_custom_modules, only: %i[edit]
  layout :resolve_layout

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
    update_package
  end

  def sign_in_as_admin
    @user = @organization.users.with_role :admin
    bypass_sign_in_with_user
  end

  def sign_in_as_user
    @user = @organization.users.where(id: params[:user_id])
    bypass_sign_in_with_user
  end

  def edit_details
    @organization = current_user.organization
  end

  def toggle_access_custom_module
    @custom_module = GeneralModule.custom_modules.find_by(id: params[:module_id])
    custom_module_ids = custom_module_id_array
    if @organization.update_attributes(custom_module_ids: custom_module_ids.uniq)
      flash.now[:success] = 'Request successfully processed'
    end
  end

  private

  def set_organization
    @organization = Organization.where(id: params[:id]).first
    return unless @organization.blank?
    flash[:danger] = 'Organization not found.'
    redirect_to organizations_path
  end

  def organization_params
    params.require(:organization).permit(:name, :url, :logo,
                                         :primary_contact_first_name,
                                         :primary_contact_last_name,
                                         :primary_contact_phone,
                                         :primary_contact_email)
  end
  
  def organization_package_params
    params.require(:organization).permit(:package_id)
  end

  def bypass_sign_in_with_user
    if @organization && @user
      bypass_sign_in @user.first, scope: :user
      flash[:warning] = "NOTE : Currently logged in as #{@user.first.full_name} for #{@organization.name}."
      redirect_to dashboard_index_path
    else
      flash[:danger] = 'Unable to login as user. Please try again.'
      redirect_to organizations_path
    end
  end

  def resolve_layout
    case action_name
      when "edit_details"
        "application"
      else
        "admin"
    end
  end

  def load_custom_modules
    @custom_modules = GeneralModule.custom_modules.order('id')
  end

  def custom_module_id_array
    custom_module_ids = @organization.custom_module_ids
    custom_module_ids = params[:disable] ? custom_module_ids.reject { |id| id == params[:module_id].to_i}
                                         : custom_module_ids << params[:module_id]
  end

  def update_package
    org_package = @organization.organization_package
    org_package ? org_package.update(organization_package_params)
                : @organization.create_organization_package(organization_package_params)
  end
end
