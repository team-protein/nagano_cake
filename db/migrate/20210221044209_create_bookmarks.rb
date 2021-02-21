class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :customer_id
      t.integer :product_id

      t.timestamps
    end
  end
end
