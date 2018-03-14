class CreateSectionGuides < ActiveRecord::Migration[5.1]
  def change
    create_table :section_guides do |t|
      t.string :section_name
      t.text :section_info

      t.timestamps
    end
  end
end
