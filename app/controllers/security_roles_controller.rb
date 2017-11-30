class SecurityRolesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_security_role, only: [:edit, :update, :destroy]
  respond_to :js

  def index
    @security_roles = current_org.security_roles.paginate(page: params[:page], per_page: 8)
  end

  def new
    @security_role = current_org.security_roles.new
  end

  def create
    @security_role = current_org.security_roles.create(security_role_params)
    if @security_role
      flash[:success] = "Security Role successfully added."
      load_security_roles
    end
  end

  def edit

  end

  def update
    if @security_role.update(security_role_params)
      flash[:success] = "Security Role successfully updated."
      load_security_roles
    end
  end

  def destroy
    if @security_role.destroy
      flash[:success] = "Security Role successfully deleted."
      load_security_roles
    end
  end

  private

  def security_role_params
    params.require(:security_role).permit(:name, projects: [:read, :create, :update, :delete, :assign], 
                                            sites: [:read, :create, :update, :delete, :assign],
                                            contacts: [:read, :create, :update, :delete, :assign],
                                            configuration: [:read, :create, :update, :delete, :assign],
                                            users: [:read, :create, :update, :delete, :assign],
                                            companies: [:read, :create, :update, :delete, :assign])
  end

  def load_security_roles
    @security_roles = current_org.security_roles.paginate(page: params[:page], per_page: 8)
  end

  def set_security_role
    @security_role = current_org.security_roles.where(id: params[:id]).first
    if @security_role.blank?
      flash.now[:danger] = "Could not find the security role."
      redirect_to settings_path
    end
  end

end