class EmailWorker
  include Sidekiq::Worker

  def perform(email_id)
    email = Email.find_by_id(email_id)
    organization_contacts = email.organization.contacts
    assignable_contact_emails = email.sent_to.split(",").collect{|email| email.strip} unless email.sent_to.nil?

    if !assignable_contact_emails.nil?
      assignable_contact_emails.each do |email_address|
        assign_contact_project(email_address, email, organization_contacts)
      end
    end

  end

  def assign_contact_project(email_address, savedEmail, org_contacts)
    contact = org_contacts.find_by_email(email_address)

    if contact.present?
      savedEmail.contacts << contact
      if contact.projects.count == 1
        savedEmail.update(mailable_id: contact.projects.first.id,
                     mailable_type: 'Project')
      end
    else
      new_contact = org_contacts.new(email: email_address, name: email_address.split("@")[0])
      new_contact.save(validate: false)
      savedEmail.contacts << new_contact
    end
  end

end
