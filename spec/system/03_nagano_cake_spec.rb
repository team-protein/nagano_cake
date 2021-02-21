require 'rails_helper'

describe '③製作～発送' do

  describe '管理者側のテスト' do

    let(:admin) { create(:admin) }
    let(:customer) { create(:customer) }
    let(:genre) { create(:genre) }
    let(:product) { create(:product, genre_id: genre.id) }
    let!(:order) { create(:order, customer_id: customer.id) }
    let!(:orderd_product) { create(:ordered_product, order_id: order.id, product_id: product.id) }

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
      end

      context 'ステータス更新のテスト' do
        before do
          visit admin_order_path(order)
          select "入金確認", from: "status"
          click_button '更新', match: :first
        end
        it '製作ステータスが「製作待ち」になっているか' do
          expect(page).to have_select(id="status", selected: '入金確認')
          expect(page).to have_select(id="making_status", selected: '製作待ち')
        end
        it '製作ステータスの更新は反映されるか' do
          select "製作中", from: "making_status"
          find('#making-status-btn').click
          expect(page).to have_select(id="status", selected: '製作中')
        end
        it '製作ステータスがすべて「製作完了」になると注文ステータスが「発送準備中」になるか' do
          select "製作完了", from: "making_status"
          find('#making-status-btn').click
          expect(page).to have_select(id="status", selected: '発送準備中')
        end
        it '注文ステータスの更新は反映されるか' do
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

  describe '会員側のテスト' do

    let(:admin) { create(:admin) }
    let(:customer) { create(:customer) }
    let(:genre) { create(:genre) }
    let(:product) { create(:product, genre_id: genre.id) }
    let!(:order) { create(:order, customer_id: customer.id, status: 'shipping_complete') }
    let!(:orderd_product) { create(:ordered_product, order_id: order.id, product_id: product.id) }

    before do
      # 以下の記述でもテスト通るが、
      # 記述が多いためlet(:order)のorder.status: 'shipping_complete'で省略
      # visit new_admin_session_path
      # fill_in 'admin[email]', with: admin.email
      # fill_in 'admin[password]', with: admin.password
      # click_button 'ログイン'
      # visit admin_order_path(order)
      # select "入金確認", from: "status"
      # click_button '更新', match: :first
      # select "製作完了", from: "making_status"
      # find('#making-status-btn').click
      # select "発送完了", from: "status"
      # click_button '更新', match: :first
      # click_link 'ログアウト'
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
    end

    describe 'ログイン後の表示の確認' do
      it 'ログイン後の遷移先は root_path であるか' do
        expect(current_path).to eq('/')
        expect(page).to have_content('ようこそ、' + customer.last_name + 'さん！')
      end

      context 'ヘッダーの表示の確認' do
        subject { current_path }

        it 'マイページを押すと、会員詳細画面に遷移する' do
          click_link 'マイページ'
          is_expected.to eq '/customers/my_page'
        end
        it '商品一覧を押すと、商品一覧画面に遷移する' do
          click_link '商品一覧'
          is_expected.to eq '/products'
        end
        it 'カートを押すと、カート一覧画面に遷移する' do
          click_link 'カート'
          is_expected.to eq '/cart_products'
        end
      end
    end

    describe '注文履歴の確認' do
      before do
        click_link 'マイページ'
      end

      context 'マイページの確認' do
        it 'URLが正しいか' do
          expect(current_path).to eq('/customers/my_page')
        end
      end

      context '注文履歴一覧の確認' do
        before do
          find('#orders-link').click
        end
        it 'URLは正しいか' do
          expect(current_path).to eq('/orders')
        end
      end

      context '注文履歴詳細の確認' do
        before do
          visit order_path(order)
        end
        it 'URLは正しいか' do
          expect(current_path).to eq('/orders/' + order.id.to_s )
        end
        it '注文ステータスが「発送完了」になっているか' do
          expect(page).to have_content('発送完了')
        end
      end
    end

  end
end