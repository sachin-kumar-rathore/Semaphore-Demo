class TempContact < ApplicationRecord
  belongs_to :user

  def self.insert_records(current_user, contacts)
    organization_contacts = current_user.organization.contacts
    contacts.each do |contact|
      next unless contact.email_addresses.present?
      existing_contacts = organization_contacts.where(email: contact.email_addresses.map(&:address))
      if existing_contacts.present?
        existing_contacts.map { | existing_contact| create_temp_contact(current_user, contact, existing_contact) }
      else
        create_temp_contact(current_user, contact)
      end
    end
  end

  def filtered_attributes
    TempContact.filter_attributes(attributes)
  end

  private

  def self.create_temp_contact(current_user, contact, existing_contact=nil)
    email = existing_contact ? existing_contact.email : contact.email_addresses[0].address
    temp_contact = current_user.temp_contacts.new(name: [contact.given_name, contact.surname].join(' '),
                                      email: email,
                                      title: contact.title,
                                      address_line_1: contact.home_address.street,
                                      city_state_zip: [contact.home_address.city, contact.home_address.state, contact.home_address.postal_code].join(' '),
                                      phone_number_1: contact.mobile_phone,
                                      cell_phone: contact.home_phones[0],
                                      notes: contact.personal_notes,
                                      exist: existing_contact ? true : false)

    temp_contact.save unless check_for_same_data(temp_contact, existing_contact)
  end

  def self.check_for_same_data(temp_contact, existing_contact)
    temp_contact_attrs = temp_contact.attributes.select{|key, value| value.present?  }
    return existing_contact ? filter_attributes(temp_contact_attrs) <= existing_contact.attributes : false
  end

  def self.filter_attributes(attrs)
    attrs.slice('name', 'email', 'title', 'cell_phone', 'address_line_1',
                     'phone_number_1', 'city_state_zip', 'notes')
  end
end
