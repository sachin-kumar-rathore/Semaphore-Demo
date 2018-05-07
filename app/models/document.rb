require 'searchable'
class Document < ApplicationRecord
  audited associated_with: :documentable
  include Searchable
  
  mount_uploader :name, FileUploader
  belongs_to :organization
  belongs_to :user, optional: true
  belongs_to :documentable, polymorphic: true, optional: true
  before_save :update_size, if: :edlt_file?
  
  scope :without_activity, -> { where("documentable_type IS NULL OR documentable_type != (?)", "Activity") }
  scope :filter_by_doc_type, ->(doc_type) { where(file_type: doc_type) }
  scope :dropbox_files, -> { where(file_type: 'Dropbox') }

  private
  
  def update_size
    if name.present? && name_changed?
      self.size = name.file.size
    end
  end

  def edlt_file?
    file_type == 'EDLT'
  end
end
