class ChangeColumnsWithDefaultValueInProject < ActiveRecord::Migration[5.1]
  def change
    change_column :projects, :wages, :decimal, default: 0
    change_column :projects, :net_new_investment, :decimal, default: 0
  end
end
