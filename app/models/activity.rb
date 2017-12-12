class Activity < ApplicationRecord

  include DateParser
  
  attr_accessor :contact_date_str, :follow_up_date_str

  before_validation :convert_dates_format

  belongs_to :organization
  belongs_to :company, optional: true
  belongs_to :company_activity_type
  belongs_to :provided_service
  belongs_to :contact_method_type
  has_many :notes, as: :notable, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :emails, as: :mailable, dependent: :destroy
  
  validates :activity_number, uniqueness: true, presence: true, length: { is: 6 }
  validates :name , presence: true

  private

  def convert_dates_format
    self.contact_date = convert_date(contact_date_str) if contact_date_str.present? rescue nil
    self.follow_up_date = convert_date(follow_up_date_str) if follow_up_date_str.present? rescue nil
  end

end
