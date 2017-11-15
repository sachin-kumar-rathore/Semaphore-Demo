class Document < ApplicationRecord

  mount_uploader :name, FileUploader
  belongs_to :organization
  belongs_to :project, optional: true
  belongs_to :user

  before_save :update_size
  
  private
  
  def update_size
    if name.present? && name_changed?
      self.size = name.file.size
    end
  end

end
