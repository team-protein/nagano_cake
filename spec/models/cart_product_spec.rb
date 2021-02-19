# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartProduct, 'CartProductモデルのテスト', type: :model do
  it '有効なカート商品は保存されるか' do
    customer = FactoryBot.create(:customer)
    product = FactoryBot.create(:product)
    cart_product = FactoryBot.build(:cart_product, customer_id: customer.id, product_id: product.id)
    expect(cart_product).to be_valid
  end
  context 'バリデーションのテスト' do
    it 'quantityカラムが空欄でないこと' do
      customer = FactoryBot.create(:customer)
      product = FactoryBot.create(:product)
      cart_product = CartProduct.new(quantity: nil, customer_id: customer.id, product_id: product.id)
      expect(cart_product).to be_invalid
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Customerモデルとの関係' do
      it 'N:1になっている' do
        expect(CartProduct.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'Productモデルとの関係' do
      it 'N:1になっている' do
        expect(CartProduct.reflect_on_association(:product).macro).to eq :belongs_to
      end
    end
  end
<<<<<<< Updated upstream
end
=======
end
>>>>>>> Stashed changes
