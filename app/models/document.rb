require 'searchable'
class Document < ApplicationRecord

  include Searchable
  
  mount_uploader :name, FileUploader
  belongs_to :organization
  belongs_to :user, optional: true
  belongs_to :documentable, polymorphic: true, optional: true
  before_save :update_size
  
  scope :without_activity, -> { where("documentable_type IS NULL OR documentable_type != (?)", "Activity") }

  private
  
  def update_size
    if name.present? && name_changed?
      self.size = name.file.size
    end
  end

end
