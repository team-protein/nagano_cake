# # frozen_string_literal: true
# require 'rails_helper'

# RSpec.describe Genre, 'Genreモデルのテスト', type: :model do

#   let(:other_genre){ create(:genre) }
#   let!(:genre){ build(:genre) }

#   describe 'バリデーションのテスト' do
#     it 'nameカラムが空欄でないこと' do
#       genre.name = ''
#       is_expected.to eq false
#     end
#     it 'nameカラムが一意であること' do
#       genre.name = other_genre.name
#       is_expected.to eq false
#     end
#   end

#   describe 'アソシエーションのテスト' do
#     context 'Productモデルとの関係' do
#       it '1:Nになっているか' do
#         expect(Genre.reflect_on_association(:products).macro).to eq :has_many
#       end
#     end
#   end
# end