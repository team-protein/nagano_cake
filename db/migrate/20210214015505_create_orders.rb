class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.string :postcode, null: false
      t.string :address, null: false
      t.string :dear, null: false
      t.integer :total_price, null: false
      t.integer :shipping_cost, null: false
      t.integer :payment_method, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
