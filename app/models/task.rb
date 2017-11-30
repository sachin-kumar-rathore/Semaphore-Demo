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
  validates_presence_of :name, :assignee_id, :user_id, :priority
  validates :priority, inclusion: { in: Task::PRIORITY,
    message: "%{value} is not a valid priority" }
  validates :status, inclusion: { in: Task::STATUS,
    message: "%{value} is not a valid status" }
  validate :end_date_is_greater_than_start_date

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
  
  def end_date_is_greater_than_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before the start date") 
    end 
  end

end
