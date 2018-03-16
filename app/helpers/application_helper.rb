require 'uri'
module ApplicationHelper
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
end
