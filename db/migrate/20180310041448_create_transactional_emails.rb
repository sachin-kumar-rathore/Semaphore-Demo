class CreateTransactionalEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :transactional_emails do |t|
      t.text          :subject
      t.text          :body
      t.integer       :type_id, unique: true
      t.string        :name

      t.timestamps
    end
  end
end
