class ManageGeneralModulesController < ApplicationController

  def authorized_module?
    match_enabled_module(get_current_section_name)
  end

  def match_enabled_module(section_name)
    general_module = GeneralModule.find_by(controller_name: section_name)
    ids = current_org.enabled_modules.ids << current_org.custom_module_ids
    unless ids.flatten.uniq.include?(general_module.id)
      redirect_to root_path
      #flash[:danger] = "You don't have access to requested page"
    end
  end

  private

  def get_current_section_name
    url = URI.parse(request.original_url)
    url.path.split("/").drop(1).first
  end
end