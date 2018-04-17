class ProjectEmailWorker
  include Sidekiq::Worker

  def perform(type, contact_email, project_id)
    begin
      emails = Email.receiver(contact_email)
      emails.each do |email|
        if type == 'assign'
          email.update(mailable_id: project_id, mailable_type: 'Project')
        else
          email.update(mailable_id: nil, mailable_type: nil)
        end
      end
    rescue Exception => e
      nil
    end
  end

end
