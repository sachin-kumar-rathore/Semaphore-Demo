class ModuleOneController < ManageCustomModulesController
  before_action :authenticate_user!
  before_action :authenticate_custom_module

  def index; end
end
