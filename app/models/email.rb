class Email < ApplicationRecord

  # == Constants == #
  self.per_page = 5

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #
  require 'date'

  # == Associations and Nested Attributes == #
  belongs_to :organization
  belongs_to :project, optional: true
  has_and_belongs_to_many :contacts


  # == Validations == #

  # == Callbacks == #

  # == Scopes == #
  scope :project, -> (project) { where("project_id = ?", project)}
  scope :contact, -> (contact) { where(contacts: {id: contact})}

  # == Instance methods == #
  def generate_email(params)
    self.sent_by = params['sender']
    self.sent_to = params['To'] if params['To'].present? rescue nil
    self.cc = params['Cc'] if params['Cc'].present? rescue nil
    self.email_date = params['Date'] if params['Date'].present? rescue nil
    self.subject = params['Subject'] if params['Subject'].present? rescue nil
    self.body = params['body-plain'] if params['body-plain'].present? rescue nil
    self.messageID = params['Message-Id'] if params['Message-Id'].present? rescue nil
  end

  # == Private == #


end
