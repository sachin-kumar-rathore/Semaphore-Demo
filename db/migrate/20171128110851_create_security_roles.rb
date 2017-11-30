class CreateSecurityRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :security_roles do |t|
      t.string :name
      t.hstore :projects, default: {}
      t.hstore :users, default: {}
      t.hstore :configuration, default: {}
      t.hstore :sites, default: {}
      t.hstore :contacts, default: {}
      t.hstore :companies, default: {}
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
