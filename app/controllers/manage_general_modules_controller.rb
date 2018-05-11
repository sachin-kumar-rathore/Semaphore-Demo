class ManageGeneralModulesController < ApplicationController

  def authorized_module?
    get_sections.each do |section|
      break if match_enabled_module(section)
    end
  end

  def match_enabled_module(section_name)
    general_module = GeneralModule.find_by(controller_name: section_name)
    return unless general_module.present?
    ids = current_org.enabled_modules.ids << current_org.custom_module_ids
    result = ids.flatten.uniq.include?(general_module.id) && current_user.can_access_module?(section_name)
    redirect_root and return true unless result
  end

  def authorized_user_to_write?
    get_sections.each do |section|
      general_module = GeneralModule.find_by(controller_name: section)
      return unless general_module.present?
      unless current_user.can_write?(section)
        mark_as_suspicious_activity(general_module)
        redirect_root and return
      end
    end
  end

  private

  def get_sections
    split_url.reject { |element| element.scan(/\D/).empty? }
  end

  def url
    URI.parse(request.original_url)
  end

  def split_url
    path_elements = url.path.split("/").drop(1)
    (action_name == 'index') ? path_elements : path_elements.tap(&:pop)
  end

  def redirect_root
    redirect_to root_path
    #flash[:danger] = "You don't have access to requested page"
  end

  def mark_as_suspicious_activity(module_controller)
    current_org.suspicious_activities.create(user_id: current_user.id, general_module_id: general_module.id)
  end
end