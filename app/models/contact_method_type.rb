class ContactMethodType < ApplicationRecord
  belongs_to :organization
  validates :name, presence: true

  CONTACT_METHOD_TYPE = ["Email", "Meeting", "Phone", "Promotional Mailing"]

  def self.create_configs( org_id )
    CONTACT_METHOD_TYPE.each do |name|
      self.create!( name: name, organization_id: org_id )
    end
  end
end
