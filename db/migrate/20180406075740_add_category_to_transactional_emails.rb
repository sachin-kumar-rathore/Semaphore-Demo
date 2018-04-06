class AddCategoryToTransactionalEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :transactional_emails, :category_id, :integer
  end
end
