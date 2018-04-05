class TransactionalEmail < ApplicationRecord

  # == Constants == #
  TYPES = [
      {name: 'Welcome New Organization', type_id: 1},
      {name: 'Welcome First User', type_id: 2},
      {name: 'Reset Password', type_id: 3},
      {name: 'Reset Password Confirmation', type_id: 4},
      {name: 'New Task Creation', type_id: 5},
      {name: 'New Task Assigned', type_id: 6},
      {name: 'New Tasks Re-Assigned', type_id: 7}
  ]
  
  EMAIL_ROLES = {
                  org_admins: 'All Org Admins',
                  org_users: 'All Org Users',
                  all: 'All System Users',
                  org: 'Org',
                  first_org_admin: 'First Org Admin'
                }
  
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
