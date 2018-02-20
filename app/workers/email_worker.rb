class EmailWorker
  include Sidekiq::Worker

  def perform(email)
    contact = email.organization.contacts.find_by_email(email.sent_by)
    if contact.present?
      email.contacts << contact
      if contact.projects.count == 1
        email.update(mailable_id: contact.projects.first.id,
                     mailable_type: 'Project')
      end
    else
      new_contact = email.organization.contacts.new(email: email.sent_by)
      new_contact.save(validate: false)
      email.contacts << new_contact
    end
  end
end
