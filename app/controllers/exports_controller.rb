class ExportsController < ManageGeneralModulesController
  before_action :authenticate_user!, :authorized_module?
  
  def index; end
end
