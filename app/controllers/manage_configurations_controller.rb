# Manage configuration tab inside settings
class ManageConfigurationsController < ManageGeneralModulesController
  before_action :authenticate_user!, :has_admin_role
  before_action :initialize_type, except: [:index]
  before_action :set_setting_type, only: %i[edit destroy update]
  respond_to :js
  respond_to :html, only: [:index]

  def index
    Organization::SETTINGS.each do |type|
      instance_variable_set("@#{type}", current_org.send(type))
    end
  end

  def new
    @setting_type = current_org.send(@type).new
  end

  def create
    @setting_type = current_org.send(@type).create(setting_params)
    return unless @setting_type
    flash[:success] = "#{setting_type_name} successfully added."
    load_setting_types
    if params[:respond_to_ajax]
      respond_to do |format|
        format.json { render json: @setting_type }
      end
    end
  end

  def edit; end

  def update
    return unless @setting_type.update(setting_params)
    flash[:success] = "#{setting_type_name} successfully updated."
    load_setting_types
  end

  def destroy
    return unless @setting_type.destroy
    flash[:success] = "#{setting_type_name} successfully deleted."
    load_setting_types
  end

  private

  def setting_type_name
    @type.titleize.singularize
  end

  def load_setting_types
    instance_variable_set("@#{@type}", current_org.send(@type))
  end

  def setting_params
    params.require(@type.singularize.to_sym).permit(:name, :status)
  end

  def set_setting_type
    @setting_type = current_org.send(@type).where(id: params[:id]).first
    return unless @setting_type.blank?
    flash[:danger] = "#{setting_type_name} not found."
    redirect_to settings_path
  end

  def initialize_type
    if Organization::SETTINGS.include? params[:type]
      @type = params[:type]
    else
      flash[:danger] = 'Could not process action. Please try again.'
      redirect_to manage_configurations_path
    end
  end
end
