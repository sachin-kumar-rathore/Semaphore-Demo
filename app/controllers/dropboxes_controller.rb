class DropboxesController < ManageCustomModulesController
  before_action :authenticate_user!
  before_action :authenticate_custom_module
  before_action :check_dropbox_token, except: [:index, :connect, :verify_code]

  include DropboxModule
  respond_to :js

  def index
    @dropbox_files = dropbox_files.paginate(page: params[:page], per_page: 10) if current_user.dropbox_token.present?
  end

  def connect
    redirect_to authenticator.authorize_url
  end

  def verify_code
    @auth = authenticator.get_token(params["code"]) rescue nil
    if @auth.nil?
      current_user.errors.add(:invlaid, 'code')
    else
      current_user.update(dropbox_token: @auth.token)
      flash[:success] = 'Your account is successfully verified'
    end
  end

  def content
    result = client.list_folder(params[:folder_path] ? params[:folder_path] : "")
    @results = result.entries.group_by { |i| i.class.to_s.split('::').last }
    @selected_files = JSON.parse($redis.get("selected_dropbox_files")) if $redis.get('selected_dropbox_files')
  end

  def sync_files
    sync_dropbox_files if $redis.get('selected_dropbox_files')
  end
 
  def select_files
    select_dropbox_file
  end

  def download_dropbox_file
    file = dropbox_files.where(id: params[:id]).first
    begin
      link_to_file = client.get_temporary_link(file.try(:file_path)).link
    rescue Exception => e
      flash[:danger] = "Either file doesn't exist or you don't have access to requested file"
      redirect_back fallback_location: files_path
    end
    redirect_to link_to_file unless e
  end

  def destroy
    @dropbox_file = dropbox_files.find_by_id(params[:id])
    if @dropbox_file.destroy
      flash.now[:success] = 'Dropbox file has been deleted successfully'
    else
      flash.now[:danger] = 'Could not destroy dropbox file'
    end
  end

  private

  def check_dropbox_token
    redirect_to dropboxes_path unless current_user.dropbox_token.present?
  end
end
