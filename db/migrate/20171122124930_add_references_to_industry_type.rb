class AddReferencesToIndustryType < ActiveRecord::Migration[5.1]
  def change
    add_reference :industry_types, :organization, foreign_key: true
  end
end
