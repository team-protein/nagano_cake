# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, 'Genreモデルのテスト', type: :model do
  subject { genre.valid? }
  let(:other_genre) { create(:genre) }
  let!(:genre) { build(:genre) }

  describe '実際に保存してみる' do
    it '有効な投稿内容は保存されるか' do
      is_expected.to eq true
    end
  end

  context 'バリデーションのテスト' do
    it 'nameカラムが空欄でないこと' do
      genre.name = ''
      is_expected.to eq false
      expect(genre.errors[:name]).to include("を入力してください")
    end
    it 'nameカラムが一意であること' do
      genre.name = other_genre.name
      is_expected.to eq false
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