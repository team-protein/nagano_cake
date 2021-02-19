# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, 'Productモデルのテスト', type: :model do
  subject{ product.valid? }
  let(:genre) { create(:genre) }
  let!(:product) { build(:product, genre_id: genre.id) }

  describe '実際に保存してみる' do
    it '有効な投稿内容は保存されるか' do
      is_expected.to eq true
    end
  end
  
  context 'バリデーションのテスト' do
    it 'nameカラムが空欄でないこと' do
      product.name = ''
      is_expected.to eq false
      expect(product.errors[:name]).to include("を入力してください")
    end
    it 'descriptionカラムが空欄でないこと' do
      product.description = ''
      is_expected.to eq false
      expect(product.errors[:description]).to include("を入力してください")
    end
    it 'descriptionカラムが200字以内であること（200字はOK）' do
      product.description = Faker::Lorem.characters(number:200)
      is_expected.to eq true
    end
    it 'descriptionカラムが200字以内であること（201字はNG）' do
      product.description = Faker::Lorem.characters(number:201)
      is_expected.to eq false
      expect(product.errors[:description]).to include("は200文字以内で入力してください")
    end
    it 'priceカラムが空欄でないこと' do
      product.price = ''
      is_expected.to eq false
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