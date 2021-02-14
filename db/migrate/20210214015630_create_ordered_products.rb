class CreateOrderedProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :ordered_products do |t|
      t.integer :order_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, null: false
      t.integer :tax_included_price, null: false
      t.integer :making_status, default: 0, null: false

      t.timestamps
    end
  end
end
