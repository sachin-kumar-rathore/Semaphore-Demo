module ContactsHelper
  def contact_export_options
    {  
      name: 'Contact Name',
      organization: 'Organization',
      title: 'Title',
      address_line_1: 'Address 1',
      address_line_2: 'Address 2',
      city_state_zip: 'City State Zip',
      phone_number_1: 'Phone 1',
      phone_number_2: 'Phone 2',
      cell_phone: 'Cell Phone',
      fax: 'Fax',
      email: 'Email',
      website: 'Website',
      notes: 'Notes',
      contact_category: 'Categories'
    }
  end

  def get_contact_field_value(contact, field)
    associated_fields = ['contact_category', 'organization']

    if associated_fields.include?(field.to_s)
      contact.send(field).try(:name)
    else
      contact.send(field)
    end
  end
end