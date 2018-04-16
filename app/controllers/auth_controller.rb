class AuthController < ApplicationController
  before_action :authenticate_user!
  
  include AuthenticationModule

  def get_token
    token = get_token_from_code(params[:code])
    $redis.set("outlook_token", auth_params(token).to_json)
    redirect_to outlook_contacts_path
  end
end
