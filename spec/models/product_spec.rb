# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe Product, 'Productモデルのテスト', type: :model do

#   let(:genre) { create(:genre) }
#   let!(:product) { build(:product, genre_id: genre.id) }

#   describe 'バリデーションのテスト' do
#     context 'nameカラム' do
#       it '空欄でないこと' do
#         product.name = ''
#         is_expected.to eq false
#       end
#     end
#     context 'descriptionカラム' do
#       it '空欄でないこと' do
#         product.description = ''
#         is_expected.to eq false
#       end
#       it '200字以内であること' do
#         product.description = Faker::Lorem.characters(number:201)
#         is_expected.to eq false
#       end
#     end
#     context 'priceカラム' do
#       it '空欄でないこと' do
#         product.price = Faker::Number.number(number:4)
#       end
#     end
#   end

#   describe 'アソシエーションのテスト' do
#     context 'Genreモデルとの関係' do
#       it 'N:1になっている' do
#         expect(Product.reflect_on_association(:genre).macro).to eq :belongs_to
#       end
#     end
#   end
# end