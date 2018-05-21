class ManageGeneralModulesController < ApplicationController

  def authorized_module?
    get_sections.each do |section|
      break if match_enabled_module(section)
    end
  end

  def match_enabled_module(section_name)
    general_module = GeneralModule.find_by(controller_name: section_name)
    return unless general_module.present?
    result = org_module_ids.include?(general_module.id) && current_user.can_access_module?(section_name)
    redirect_root and return true unless result
  end

  def authorized_user_to_write?
    get_sections.each do |section|
      break unless verify_write_access(section)
    end
  end

  def authorized_to_write_current_section?
    verify_write_access(current_section)
  end

  def has_admin_role
    redirect_root unless current_user.is_admin?
  end

  private
  
  def current_section
    split_url.first
  end

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

  def org_module_ids
    if ids = $redis.get('org_module_ids')
      JSON.parse(ids)
    else
      ids = (current_org.enabled_modules.ids << current_org.custom_module_ids).flatten.uniq
      $redis.set('org_module_ids', ids)
      ids
    end
  end

  def redirect_root
    redirect_to root_path
    #flash[:danger] = "You don't have access to requested page"
  end

  def mark_as_suspicious_activity(module_controller)
    current_org.suspicious_activities.create(user_id: current_user.id, general_module_id: module_controller.id)
  end

  def verify_write_access(section)
    general_module = GeneralModule.find_by(controller_name: section)
    return unless general_module.present?
    unless current_user.can_write?(section)
      mark_as_suspicious_activity(general_module) unless request.get?
      redirect_root and return false
    end
  end
end