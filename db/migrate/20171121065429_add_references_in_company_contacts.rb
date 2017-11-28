class AddReferencesInCompanyContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :company_contacts, :company, foreign_key: true
    add_reference :company_contacts, :contact, foreign_key: true
  end
end
