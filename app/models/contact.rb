class Contact < ApplicationRecord

  attr_accessor :project_id
  # == Constants == #
  self.per_page = 5

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #
  include PgSearch

  # == Associations and Nested Attributes == #
  belongs_to :organization
  has_many :project_contacts, dependent: :destroy
  has_many :projects, through: :project_contacts
  has_and_belongs_to_many :emails


  # == Validations == #
  validates_presence_of :name, :email
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Invalid"

  # == Callbacks == #
  after_create :add_contact_to_project, if: :has_project_id? 
  # == Scopes and Other macros == #
  pg_search_scope :name_search, :against => :name, :using => {
      :tsearch => {:prefix => true}
  }
  pg_search_scope :email_search, :against => :email, :using => {
      :tsearch => {:prefix => true}
  }

  # == Instance methods == #
  def self.name_or_email_search(name, email)
    name_relation = name_search(name).pluck(:id)
    email_relation = email_search(email).pluck(:id)
    search_result = name_relation | email_relation
    return where('id IN (?)', search_result)
  end

  # == Private == #
  def add_contact_to_project
    self.project_contacts.create!(project_id: project_id)
  end

  def has_project_id?
    project_id.present?    
  end

end
