class TransactionalEmail < ApplicationRecord

  # == Constants == #  
  EMAIL_ROLES = {
                  org_admins: 'All Org Admins',
                  org_users: 'All Org Users',
                  all: 'All System Users',
                  org: 'Org',
                  first_org_admin: 'First Org Admin'
                }
  
  has_many :subcategories, class_name: 'TransactionalEmail', foreign_key: :category_id
 
  # == Attributes == #
  attr_accessor :send_to

  # == Callbacks == #
  before_create :assign_unique_type_id

  validates_presence_of :name, :subject, :body

  private

  def assign_unique_type_id
    self.type_id  = TransactionalEmail.all.count > 0 ? (TransactionalEmail.last.type_id + 1) : 1
  end

end
