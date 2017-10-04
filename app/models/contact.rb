class Contact < ApplicationRecord

  # == Constants == #

  # == Attributes == #

  # == File Uploader == #

  # == Associations and Nested Attributes == #
  # belongs_to :company
  # has_many :project_contacts
  # has_many :projects, through: :project_contacts

  # == Validations == #
  validates_presence_of :name, :email

  # == Callbacks == #

  # == Scopes and Other macros == #

  # == Instance methods == #

  # == Private == #

end
