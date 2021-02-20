require 'rails_helper'

describe '③製作～発送' do
  let(:admin) { create(:admin) }
  let(:customer) { create(:customer) }
  let(:genre) { create(:genre) }
  let(:product) { create(:product, genre_id: genre.id) }
  let!(:order) { create(:order, customer_id: customer.id) }
  let!(:orderd_product) { create(:ordered_product, order_id: order.id, product_id: product.id) }

  describe '管理者側の処理' do

    before do
      visit new_admin_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
    end

    describe 'ログイン後の表示の確認' do
      it 'ログイン後の遷移先は admin/orders であるか' do
        expect(current_path).to eq('/admin/orders')
      end
    end

    describe '注文履歴の確認' do
      before do
        orders_link = find_all('a')[3].native.inner_text
        orders_link = orders_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link orders_link
      end
      context '表示内容の確認' do
        it 'URLが正しいか' do
          expect(current_path).to eq('/admin/orders')
        end
      end
      context '注文詳細画面表示のテスト' do
        before do
          visit admin_order_path(order)
        end
        it 'URLが正しいか' do
          expect(current_path).to eq ('/admin/orders/' + order.id.to_s)
        end
        it '注文ステータスのプルダウンが表示されているか' do
          expect(page).to have_select(id="status", selected: '入金待ち')
        end
        it '製作ステータスのプルダウンが表示されているか' do
          expect(page).to have_select(id="making_status", selected: '製作不可')
        end
        it '注文ステータスの更新ボタンが表示されているか' do
          expect(page).to have_button '更新'
        end
        it '注文ステータスを入金済みに更新する' do
          select "入金確認", from: "status"
          click_button '更新', match: :first
          expect(page).to have_select(id="status", selected: '入金確認')
          expect(page).to have_select(id="making_status", selected: '製作待ち')
        end
        it '製作ステータスを1つ「製作中」にする' do
          select "入金確認", from: "status"
          click_button '更新', match: :first
          select "製作中", from: "making_status"
          find('#making-status-btn').click
          expect(page).to have_select(id="status", selected: '製作中')
        end
        it '製作ステータスをすべて「製作完了」にする' do
          select "入金確認", from: "status"
          click_button '更新', match: :first
          select "製作完了", from: "making_status"
          find('#making-status-btn').click
          expect(page).to have_select(id="status", selected: '発送準備中')
        end
        it '注文ステータスを「発送済み」にする' do
          select "入金確認", from: "status"
          click_button '更新', match: :first
          select "製作完了", from: "making_status"
          find('#making-status-btn').click
          select "発送完了", from: "status"
          click_button '更新', match: :first
          expect(page).to have_select(id="status", selected: '発送完了')
        end
      end

      context 'ログアウト後の遷移先は正しいか' do
        it 'ログアウト後の遷移先は admin/sing_in であるか' do
          click_link 'ログアウト'
          expect(current_path).to eq('/admin/sign_in')
        end
      end
    end
  end
  
  
end