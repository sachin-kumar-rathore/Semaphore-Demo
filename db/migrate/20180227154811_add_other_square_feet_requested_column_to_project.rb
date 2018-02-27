class AddOtherSquareFeetRequestedColumnToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :other_square_ft_requested, :integer, default: 0
  end
end
