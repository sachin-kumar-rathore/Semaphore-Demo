class Company < ApplicationRecord

  # == Constants == #

  # == Attributes == #
  attr_accessor :lease_expiration_date_str, :date_of_total_str
  # == File Uploader == #

  # == Modules == #
  include DateParser
  # == Associations and Nested Attributes == #

  # == Validations == #
  validates_presence_of :name, :company_number
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :projects
  has_many :company_contacts, dependent: :destroy
  has_many :contacts, through: :company_contacts
  belongs_to :organization

  # == Callbacks == #
  before_validation :convert_dates_format
  # == Scopes and Other macros == #

  # == Instance methods == #

  # == Private == #

  def convert_dates_format
    self.lease_expiration_date = convert_date(lease_expiration_date_str) if lease_expiration_date_str.present? rescue nil
    self.date_of_total = convert_date(date_of_total_str) if date_of_total_str.present? rescue nil
  end
end
