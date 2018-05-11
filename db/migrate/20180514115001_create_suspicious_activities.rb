class CreateSuspiciousActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :suspicious_activities do |t|
      t.references :organization, foriegn_key: true
      t.references :user, foriegn_key: true
      t.references :general_module, foriegn_key: true
      t.timestamps
    end
  end
end
