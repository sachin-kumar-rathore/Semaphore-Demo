require 'uri'
module ApplicationHelper
  include Constant

  def load_active_type(type)
    current_org.send(type).active.map{ |type| [type.name, type.id] }
  end

  def load_type(type)
    current_org.send(type).map{ |type| [type.name, type.id] }
  end

  def load_data_with_id(object)
    object.all.map { |type| [type.name, type.id] }
  end

  def active_class(section_name)
    return unless get_current_section_name.eql? section_name
    'active'
  end

  def priority_class(priority)
    case priority
    when "High"
      'dotHigh'
    when "Medium"
      'dotMedium'
    else
      ''
    end
  end

  def assign_default_object_number(object)
    object_number_records = current_org.send(object.pluralize).pluck((object + '_number').to_sym)
    while true
      rand_num = rand.to_s[2..7]
      return rand_num unless object_number_records.include?(rand_num.to_s)
    end
  end

  def get_current_section_name
    url = URI.parse(request.original_url)
    url.path.split("/").drop(1).first
  end

  def load_type_with_quick_add(type, record_name)
    load_type(type) + [['[+ QUICK ADD +] New ' + record_name, 'Quick add']]
  end

  def enabled_custom_modules_list
    current_org.custom_modules.side_bar_modules
  end
  
  def logo_redirect_path
    if current_admin
      organizations_path
    elsif current_user
      dashboard_index_path
    else
      root_path
    end     
  end

  def side_bar_default_modules
    current_org.enabled_modules.side_bar_modules.all_except('manage_users')
  end

  def module_icon(module_controller)
    Constant::MODULE_ICONS[module_controller.to_sym].split(', ')
  end

  def can_write?(module_controller=get_current_section_name)
    current_user.can_write?(module_controller)
  end

  def disabled_form?(module_controller=nil)
    result = module_controller && (module_controller != get_current_section_name) ? (can_write? && can_write?(module_controller)) : can_write?
    result ? '' : "disabled=disabled"
  end

  def edit_view_class
    can_write? ? 'md-edit' : 'fa fa-eye'
  end
end
