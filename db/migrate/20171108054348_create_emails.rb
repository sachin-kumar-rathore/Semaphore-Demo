class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.integer     :organization_id
      t.integer     :project_id
      t.string      :sent_by
      t.string      :sent_to
      t.string      :subject
      t.string      :messageID, unique: true
      t.text        :body
      t.datetime    :email_date

      t.timestamps
    end
  end
end
