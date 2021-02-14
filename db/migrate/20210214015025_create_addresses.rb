class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.integer :customer_id, null: false
      t.string :postcode, null: false
      t.string :address, null: false
      t.string :dear, null: false

      t.timestamps
    end
  end
end
