class AddRecievingRolesToTransactionalEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :transactional_emails, :recipient_roles, :string
  end
end
