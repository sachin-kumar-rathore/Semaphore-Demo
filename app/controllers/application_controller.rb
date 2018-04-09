# Manage common code for whole application
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  helper_method :current_org

  def after_sign_in_path_for(resource)
    if resource.instance_of? Admin
      organizations_path
    else
      dashboard_index_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    else
      $redis.del "marked_sections"
      root_path
    end
  end

  def configure_permitted_parameters
    added_attrs = %i[first_name last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
    devise_parameter_sanitizer.permit(:accept_invitation, keys: added_attrs)
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "layouts/error_404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def current_org
    current_user.organization
  end

  def assign_message_and_status_for_id_validity(type)
    @records = assign_records(type)
    instance_variable_set('@type', @records)
    if @type.where((type.singularize + '_number')
            .to_sym => params[:data]).blank?
      @message = "#{type.titleize.singularize} ID is unique."
      @status = true
    else
      @message = "#{type.titleize.singularize} already exists."
      @status = false
    end
  end

  def assign_records(type)
    if params[:id].present?
      current_org.send(type).where.not(id: params[:id])
    else
      current_org.send(type)
    end
  end

  def authenticate_custom_module
    custom_module = CustomModule.find_by(controller_name: params[:controller])
    unless current_org.custom_module_ids.include?(custom_module.id)
      redirect_to dashboard_index_path
      flash[:danger] = "You don't have access to requested page"
    end
  end
end
