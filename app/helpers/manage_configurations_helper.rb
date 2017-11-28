module ManageConfigurationsHelper
  def setting_list
    instance_variable_get("@#{@type}")
  end
end
