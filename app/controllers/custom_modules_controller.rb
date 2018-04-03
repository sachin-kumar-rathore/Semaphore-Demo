class CustomModulesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_custom_module, except: %[index enable_disable_custom_module]
  before_action :set_organization, only: %[enable_disable_custom_module]

  def index
    @custom_modules = CustomModule.all.order('id ASC')
  end

  def edit; end

  def update
    if @custom_module.update(custom_module_params)
      flash[:success] = 'Custom module has been successfully updated'
      redirect_to custom_modules_path
    else
      render :edit
    end
  end

  def show_org_list
    @organizations = params[:disable] ? Organization.where('custom_module_ids && ARRAY[?]', @custom_module.id).order('id desc')
                     : Organization.where.not('custom_module_ids && ARRAY[?]', @custom_module.id).order('id desc')
  end

  def enable_disable_custom_module
    if @organization
      custom_module_ids = custom_module_id_array
      if @organization.update_attributes(custom_module_ids: custom_module_ids.uniq)
        flash[:success] = 'Request successfully processed'
      else
        flash[:danger] = 'Could not process request'
      end
      redirect_to custom_modules_path
    end
  end

  private
  
  def custom_module_params
    params.require(:custom_module).permit(:name)
  end

  def set_custom_module
    @custom_module = CustomModule.find_by_id(params[:id])
  end

  def set_organization
    @organization = Organization.find_by_id(params[:organization_id])
    return unless @organization.blank?
    flash[:danger] = 'Organization not found.'
    redirect_to custom_modules_path
  end

  def custom_module_id_array
    custom_module_ids = @organization.custom_module_ids
    custom_module_ids = params[:disable] ? custom_module_ids.reject { |id| id == params[:id].to_i}
                                           : custom_module_ids << params[:id]
  end
end
