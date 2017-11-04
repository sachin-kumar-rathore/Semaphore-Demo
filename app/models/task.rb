class Task < ApplicationRecord

  attr_accessor :start_date_str, :end_date_str
  # == Constants == #
  STATUS = ['In-Progress', 'Complete']
  PRIORITY = ['High', 'Medium', 'Low']

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #
  include DateParser
  # == Associations and Nested Attributes == #
  belongs_to :user
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  belongs_to :project, optional: true
  # belongs_to :project

  # == Validations == #
  validates_presence_of :name, :assignee_id

  # == Callbacks == #
  before_validation :convert_dates_format
  # == Scopes and Other macros == #
  
  # == Instance methods == #

  # == Private == #
  private

  def convert_dates_format
    self.start_date = convert_date(start_date_str) if start_date_str.present? rescue nil
    self.end_date = convert_date(end_date_str) if end_date_str.present? rescue nil
  end

end
