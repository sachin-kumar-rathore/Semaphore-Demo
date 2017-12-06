class ManageConfigurationsController < ApplicationController

  before_action :authenticate_user!
  before_action :initialize_type, except: [:index]
  before_action :set_setting_type, only: [:edit, :destroy, :update]
  respond_to :js

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
    if @setting_type
      flash[:success] = "#{setting_type_name} successfully added."
      load_setting_types
    end
  end

  def edit

  end

  def update
    if @setting_type.update(setting_params)
      flash[:success] = "#{setting_type_name} successfully updated."
      load_setting_types
    end
  end

  def destroy
    if @setting_type.destroy
      flash[:success] = "#{setting_type_name} successfully deleted."
      load_setting_types
    end
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
    if @setting_type.blank?
      flash[:danger] = "#{setting_type_name} not found."
      redirect_to settings_path
    end
  end

  def initialize_type
    if Organization::SETTINGS.include? params[:type]
      @type = params[:type]
    else
      flash[:danger] = "Could not process action. Please try again."
      redirect_to manage_configurations_path
    end
  end

end
