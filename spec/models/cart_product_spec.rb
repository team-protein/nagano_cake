# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartProduct, 'CartProductモデルのテスト', type: :model do
  subject { cart_product.valid? }
  let(:customer) { create(:customer) }
  let(:product) { create(:product) }
  let!(:cart_product) { build(:cart_product, customer_id: customer.id, product_id: product.id) }

  describe '実際に保存してみる' do
    it '有効なカート商品は保存されるか' do
      is_expected.to eq true
    end
  end

  context 'バリデーションのテスト' do
    it 'quantityカラムが空欄でないこと' do
      cart_product.quantity = ''
      is_expected.to eq false
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
end