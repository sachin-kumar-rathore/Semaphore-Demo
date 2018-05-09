class CreateOrganizationPackages < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_packages do |t|
      t.references :organization, foriegn_key: true
      t.references :package, foriegn_key: true
    end
  end
end
