# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, 'Genreモデルのテスト', type: :model do
  it '有効な投稿内容は保存されるか' do
    expect(FactoryBot.build(:genre)).to be_valid
  end
  context 'バリデーションのテスト' do
    it 'nameカラムが空欄でないこと' do
      genre = FactoryBot.build(:genre, name: nil)
      expect(genre).to be_invalid
      expect(genre.errors[:name]).to include("を入力してください")
    end
    it 'nameカラムが一意であること' do
      other_genre = FactoryBot.create(:genre)
      genre = FactoryBot.build(:genre, name: other_genre.name)
      expect(genre).to be_invalid
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Productモデルとの関係' do
      it '1:Nになっているか' do
        expect(Genre.reflect_on_association(:products).macro).to eq :has_many
      end
    end
  end
end
