class CreateJoinTableContactEmail < ActiveRecord::Migration[5.1]
  def change
    create_join_table :contacts, :emails do |t|
      t.index [:contact_id, :email_id]
    end
  end
end
