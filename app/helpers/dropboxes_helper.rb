module DropboxesHelper

  def dropbox_file_row_class(result)
   class_name =  'file' + result.path_lower.gsub('/', '_').gsub(/[. ]/, '_')
   if $redis.get('selected_dropbox_files')
    selected_files = JSON.parse($redis.get("selected_dropbox_files"))
    selected_files.map {|file| file['file_path']}.include?(result.path_lower) ? (class_name + ' hidden') : class_name
   else
     class_name
    end
  end

  def synced_file?(file_path)
    current_org.documents.dropbox_files.where(file_path: file_path).present? ? 'fa fa-check-circle' : ''
  end

  def sync_status(file)
    if current_user.dropbox_token.present? && file.file_path
      begin
        f = client.get_metadata(file.file_path)
        rescue DropboxApi::Errors::NotFoundError => e
        rescue DropboxApi::Errors => e
      end
      f ? 'fa fa-check-circle themeColor' : 'fa fa-check-circle alerts-danger'
    end 
  end

  private

  def client
    DropboxApi::Client.new(current_user.dropbox_token)
  end
end
