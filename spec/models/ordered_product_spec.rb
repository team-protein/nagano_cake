# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderedProduct, "モデルに関するテスト", type: :model do
  it "有効な投稿内容の場合は保存されるか" do
    customer = FactoryBot.create(:customer)
    order = FactoryBot.create(:order, customer_id: customer.id)
    product = FactoryBot.create(:product)
    expect(FactoryBot.build(:ordered_product, order_id: order.id, product_id: product.id)).to be_valid
  end
  
end