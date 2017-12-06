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

  has_many :projects, dependent: :destroy
  has_many :company_contacts, dependent: :destroy
  has_many :contacts, through: :company_contacts
  belongs_to :industry_type
  belongs_to :project_type
  belongs_to :business_unit
  belongs_to :organization
  belongs_to :owner, class_name: 'Contact', foreign_key: :owner_id, optional: true
  has_many :activities, dependent: :destroy
  # == Validations == #
  validates_presence_of :name, :company_number
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :average_age_of_buildings, inclusion: { in: Company::BUILDINGS_AGE, message: "%{value} is not a valid data." }, allow_nil: true
  validates :owned_or_leased, inclusion: { in: %w(Owned Leased), message: "%{value} is not a valid data." }, allow_nil: true
  validates :peak_season, inclusion: { in: Company::SEASONS, message: "%{value} is not a valid data." }, allow_nil: true
  validates :company_number, uniqueness: true, presence: true, length: { is: 6 }
  # == Callbacks == #
  before_validation :convert_dates_format
  # == Scopes and Other macros == #
  scope :company_name, -> (company_name) { where("companies.name ilike ?","%#{company_name}%")}
  scope :industry_type_id, -> (industry_type_id) { where("companies.industry_type_id = ?",industry_type_id)}
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
