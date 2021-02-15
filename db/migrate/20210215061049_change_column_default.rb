class ChangeColumnDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :products, :image_id, from: nil, to: 'no_image.png'
  end
end
