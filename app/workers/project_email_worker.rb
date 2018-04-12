class ProjectEmailWorker
  include Sidekiq::Worker

  def perform(type, contact_id, project_id)
    begin
      contact = Contact.find_by_id(contact_id)
      contact.emails.each do |email|
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
