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
    url = URI.parse(request.original_url)
    return unless url.path.split("/").drop(1).first.eql? section_name
    'active'
  end
end
