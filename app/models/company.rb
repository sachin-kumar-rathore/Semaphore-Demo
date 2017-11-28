class Company < ApplicationRecord

  # == Constants == #
  SEASONS = ["Spring", "Summer", "Fall", "Winter"]
  BUILDINGS_AGE = ["< 10 years","11-25 years","> 25 years"]
  # == Attributes == #
  attr_accessor :lease_expiration_date_str, :date_of_total_str
  # == File Uploader == #

  # == Modules == #
  include DateParser
  # == Associations and Nested Attributes == #

  # == Validations == #
  validates_presence_of :name, :company_number
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :projects, dependent: :destroy
  has_many :company_contacts, dependent: :destroy
  has_many :contacts, through: :company_contacts
  belongs_to :organization
  belongs_to :owner, class_name: 'Contact', foreign_key: :owner_id, optional: true

  # == Callbacks == #
  before_validation :convert_dates_format
  # == Scopes and Other macros == #
  scope :company_name, -> (company_name) { where("companies.name ilike ?","%#{company_name}%")}
  scope :industry_type, -> (industry_type) { where("companies.industry_type = ?",industry_type)}
  scope :associated_project, ->(associated_project) {
    includes(:projects).where('projects.name ilike ?',"%#{associated_project}%").references(:projects)
  }
  scope :associated_contact, ->(associated_contact) {
    includes(:contacts).where('contacts.name ilike ?',"%#{associated_contact}%").references(:contacts)  
  }
  # == Instance methods == #

  # == Private == #

  def convert_dates_format
    self.lease_expiration_date = convert_date(lease_expiration_date_str) if lease_expiration_date_str.present? rescue nil
    self.date_of_total = convert_date(date_of_total_str) if date_of_total_str.present? rescue nil
  end
end
