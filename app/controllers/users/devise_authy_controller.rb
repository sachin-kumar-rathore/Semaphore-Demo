class Users::DeviseAuthyController < Devise::DeviseAuthyController
  before_action :request_otp_sms, only: %i[GET_verify_authy]
  before_action :check_request_format, only: %i[GET_enable_authy POST_disable_authy]
  respond_to :js, only: %i[GET_enable_authy POST_enable_authy POST_verify_authy_installation POST_disable_authy]
  layout 'custom_layout'
  
  def POST_enable_authy
    @authy_user = Authy::API.register_user(
      :email => resource.email,
      :cellphone => params[:cellphone],
      :country_code => params[:country_code]
    )

    if @authy_user.ok?
      resource.authy_id = @authy_user.id
      unless resource.save
        flash.now[:danger] = 'Something went wrong while enabling two factor authentication'
        redirect_to after_authy_enabled_path_for(resource) and return
      end
      request_otp_sms
      render layout: false
    else
      @error = 'Something went wrong while enabling two factor authentication'
      render :enable_authy
    end
  end

  def POST_verify_authy_installation
    token = Authy::API.verify({
      :id => self.resource.authy_id,
      :token => params[:token],
      :force => true
    })

    self.resource.authy_enabled = token.ok?

    if token.ok? && self.resource.save
      flash.now[:success] = 'Two factor authentication was enabled'
    else
      @error = 'Something went wrong while enabling two factor authentication'
    end
  end

  def POST_disable_authy
    response = Authy::API.delete_user(id: resource.authy_id)

    if response.ok?
      resource.update_attributes(authy_enabled: false, authy_id: nil)
      flash.now[:success] = 'Two factor authentication was disabled'
    else
      flash.now[:danger] = 'Something went wrong while disabling two factor authentication'
    end
  end

  protected
    def after_authy_enabled_path_for(resource)
      my_details_path
    end

    def after_authy_disabled_path_for(resource)
      my_details_path
    end

  private

  def request_otp_sms
    Authy::API.request_sms(id: resource ? resource.authy_id : @resource.authy_id, force: true)
  end

  def check_request_format
    redirect_to my_details_path unless request.format == :js
  end
end