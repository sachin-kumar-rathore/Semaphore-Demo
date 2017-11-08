class Email < ApplicationRecord

  require 'date'

  belongs_to :organization
  belongs_to :project, optional: true

  def generate_email(params)
    self.sent_by = params['sender']
    self.sent_to = params['Cc'] if params['Cc'].present? rescue nil
    self.email_date = params['Date'] if params['Date'].present? rescue nil
    self.subject = params['Subject'] if params['Subject'].present? rescue nil
    self.body = params['body-plain'] if params['body-plain'].present? rescue nil
    self.messageID = params['Message-Id'] if params['Message-Id'].present? rescue nil
  end
end
