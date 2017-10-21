module TasksHelper
  def assigned_to_user(id)
    User.find(id).full_name
  end
end
