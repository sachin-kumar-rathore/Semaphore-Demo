module DropboxModule
  
  private

  def authenticator
    DropboxApi::Authenticator.new(ENV["DROPBOX_APP_KEY"], ENV["DROPBOX_APP_SECRET"])
  end

  def client
    DropboxApi::Client.new(current_user.dropbox_token)
  end

  def sync_dropbox_files
    begin
      Document.transaction do
        @errors = save_records
        if @errors.blank?
          $redis.del('selected_dropbox_files')
          flash[:success] = 'Files are successfully synced.'
          redirect_to dropboxes_path
        else
          raise ActiveRecord::Rollback, "Deleting Documents........."
        end
      end
    rescue Exception => e
      @errors << e
    end
  end

  def save_records
    selected_files,errors = JSON.parse($redis.get("selected_dropbox_files")), []
    org_dropbox_files = dropbox_files
    selected_files.each_with_index do |record, index|
      file = org_dropbox_files.where(file_path: record['file_path']).first
      if file.present?
        file.attributes = file_params(record)
      else
        file = current_org.documents.new(file_params(record))
      end
      errors <<  "File #{index+1}: " + file.errors.full_messages.join(',') unless file.save
    end
    errors
  end

  def select_dropbox_file
    @selected_files = []
    @selected_files << JSON.parse($redis.get("selected_dropbox_files")) if $redis.get('selected_dropbox_files')
    @selected_files = @selected_files.flatten.reject {|file| file['file_path'] == params[:file_path]}
    @selected_files << { file_path: params[:file_path], file_name: params[:file_name], documentable_id: params[:project_id], size: params[:file_size] }.stringify_keys unless params[:discard]
    $redis.set("selected_dropbox_files", @selected_files.flatten.to_json)
  end

  def dropbox_files
    current_org.documents.dropbox_files
  end

  def file_params(params_hash)
    params_hash.merge(user_id: current_user.id, documentable_type: 'Project', file_type: 'Dropbox')
  end
end