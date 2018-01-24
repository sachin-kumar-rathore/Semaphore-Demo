require 'searchable'
class Note < ApplicationRecord

  include Searchable
  
  #Modules
  include DateParser

  attr_accessor :date_str

  #Associations
  belongs_to :notable, polymorphic: true
  
  #Callbacks
  before_validation :convert_dates_format

  #Validations
  validates_presence_of :subject, :date, :description

  #Private
  private

  def convert_dates_format
    self.date = convert_date(date_str) if date_str.present? rescue nil
  end

end
