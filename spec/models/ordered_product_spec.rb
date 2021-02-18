# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe OrderedProduct, "モデルに関するテスト", type: :model do
#   it "有効な投稿内容の場合は保存されるか" do
#     customer = FactoryBot.create(:customer)
#     expect(FactoryBot.build(:order, customer_id: customer.id)).to be_valid
#   end
#   context "バリデーションのテスト" do
#     it "postcodeが7文字でない場合無効である" do
#       customer = FactoryBot.create(:customer)
#       order = FactoryBot.build(:order, postcode: "123456", customer_id: customer.id)
#       order.valid?
#       expect(order.errors[:postcode]).to include("は7文字で入力してください")
#     end
#     it "addressが空白の場合無効である" do
#       customer = FactoryBot.create(:customer)
#       order = FactoryBot.build(:order, address: nil, customer_id: customer.id)
#       order.valid?
#       expect(order.errors[:address]).to include("を入力してください")
#     end
#     it "dearが空白の場合無効である" do
#       customer = FactoryBot.create(:customer)
#       order = FactoryBot.build(:order, dear: nil, customer_id: customer.id)
#       order.valid?
#       expect(order.errors[:dear]).to include("を入力してください")
#     end
#   end
# end