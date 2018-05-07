class AddColumnsToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :file_path, :string
    add_column :documents, :file_type, :string, default: 'EDLT'
    add_column :documents, :file_name, :string
  end
end
