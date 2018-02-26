class EmailWorker
  include Sidekiq::Worker

  def perform(email_id)
    email = Email.find_by_id(email_id)
    organization_contacts = email.organization.contacts
    contact = organization_contacts.find_by_email(email.sent_by)

    if contact.present?
      email.contacts << contact
      if contact.projects.count == 1
        email.update(mailable_id: contact.projects.first.id,
                     mailable_type: 'Project')
      end
    else
      new_contact = organization_contacts.new(email: email.sent_by)
      new_contact.save(validate: false)
      email.contacts << new_contact
    end
  end
end
