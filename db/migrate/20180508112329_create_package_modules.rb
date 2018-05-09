class CreatePackageModules < ActiveRecord::Migration[5.1]
  def change
    create_table :package_modules do |t|
      t.references :package, foreign_key: true
      t.references :general_module, foreign_key: true
    end
  end
end
