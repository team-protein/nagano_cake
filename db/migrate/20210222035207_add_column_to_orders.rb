class AddColumnToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :created_month, :string
  end
end
