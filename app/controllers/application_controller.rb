class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper_method :current_org

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

  def configure_permitted_parameters
    added_attrs = [:first_name, :last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def render_404
    render :template => 'layouts/error_404', :status => 404
  end
  
  def current_org
    current_user.organization
  end

  def set_message_and_status_for_id_validity(type)
    @records = params[:id].present? ? current_org.send(type).where.not(id: params[:id]) : current_org.send(type)
    instance_variable_set("@type", @records)
    if @type.where((type.singularize + '_number').to_sym => params[:data]).blank?
      @message = "#{type.titleize.singularize} ID is unique."
      @status = true
    else
      @message = "#{type.titleize.singularize} already exists."
      @status = false
    end
  end

end
