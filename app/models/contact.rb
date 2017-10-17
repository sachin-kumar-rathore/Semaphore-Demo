class Contact < ApplicationRecord

  # == Constants == #

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #
  include PgSearch

  # == Associations and Nested Attributes == #
  belongs_to :organization
  # has_many :project_contacts
  # has_many :projects, through: :project_contacts

  # == Validations == #
  validates_presence_of :name, :email

  # == Callbacks == #

  # == Scopes and Other macros == #
  pg_search_scope :search_contacts, :against => [:name, :email]

  # == Instance methods == #

  # == Private == #

end
