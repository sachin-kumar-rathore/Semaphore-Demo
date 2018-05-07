class ManageCustomModulesController < ApplicationController

  def authenticate_custom_module
    custom_module = CustomModule.find_by(controller_name: params[:controller])
    unless current_org.custom_module_ids.include?(custom_module.id)
      redirect_to dashboard_index_path
      flash[:danger] = "You don't have access to requested page"
    end
  end
end