# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, 'Productモデルのテスト', type: :model do
  it '有効な投稿内容は保存されるか' do
    expect(FactoryBot.build(:product)).to be_valid
  end
  context 'バリデーションのテスト' do
    it 'nameカラムが空欄でないこと' do
      genre = FactoryBot.create(:genre)
      product = FactoryBot.build(:product, name: nil, genre_id: genre.id)
      expect(product).to be_invalid
      expect(product.errors[:name]).to include("を入力してください")
    end
    it 'descriptionカラムが空欄でないこと' do
      genre = FactoryBot.create(:genre)
      product = FactoryBot.build(:product, description: nil, genre_id: genre.id)
      expect(product).to be_invalid
      expect(product.errors[:description]).to include("を入力してください")
    end
    it 'descriptionカラムが200字以内であること' do
      genre = FactoryBot.create(:genre)
      product = FactoryBot.build(:product, description: Faker::Lorem.characters(number:201), genre_id: genre.id)
      expect(product).to be_invalid
      expect(product.errors[:description]).to include("は200文字以内で入力してください")
    end
    it 'priceカラムが空欄でないこと' do
      genre = FactoryBot.create(:genre)
      product = FactoryBot.build(:product, price: nil, genre_id: genre.id)
      expect(product).to be_invalid
      expect(product.errors[:price]).to include("を入力してください")
    end
  end
    
  describe 'アソシエーションのテスト' do
    context 'Genreモデルとの関係' do
      it 'N:1になっている' do
        expect(Product.reflect_on_association(:genre).macro).to eq :belongs_to
      end
    end
  end
end