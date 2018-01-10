module SecurityRolesHelper
  def delete_method_data_string(role)
    role.users.present? ? 'data-toggle=modal data-target=#alertModal' : "data-href= #{security_role_path(role)}"
  end

  def delete_option_class(role)
    role.users.present? ? '' : 'delete-option'
  end
end
