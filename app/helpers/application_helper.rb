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
end
