class ChangeCartProductColumnToNull < ActiveRecord::Migration[5.2]
  def up
    change_column :cart_products, :quantity, :integer, null: true
  end

  def down
    change_column :cart_products, :quantity, :integer, null: false
  end
end
