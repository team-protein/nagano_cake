require 'rails_helper'

describe '登録情報変更～退会のテスト' do
  let(:customer) { create(:customer) }
  let(:genre) { create(:genre) }
  let!(:product) { create(:product, genre_id: genre.id) }
  let!(:cart_product) { create(:cart_product, product_id: product.id, customer_id: customer.id) }
  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end
  describe '商品一覧画面のテスト' do
    context '任意の商品画像を押下したとき' do
      before do
        visit products_path
        click_link product.name
      end
      it '該当商品の詳細画面に遷移する' do
        expect(current_path).to eq '/products/' + product.id.to_s
      end
      it '商品名が表示されている' do
        expect(page).to have_content product.name
      end
      it '商品の説明が表示されている' do
        expect(page).to have_content product.description
      end
    end
  end
  describe 'カート画面のテスト' do
    before do
      visit cart_products_path
    end
    it '情報入力に進むボタンを押下したとき、情報入力画面に遷移する' do
      click_link '情報入力に進む'
      expect(current_path).to eq '/orders/new'
    end
  end
  describe '新規住所での注文のテスト' do
    before do
      visit new_order_path
      choose 'payment_method_bank'
      choose 'shipping_to_2'
      fill_in 'postcode', with: "1234567"
      fill_in 'address', with: "東京都渋谷区代々木神園町0-0"
      fill_in 'dear', with: "令和道子"
      click_button '確認画面へ進む'
    end
    describe '注文情報入力画面のテスト' do
      it '任意の支払方法を選択、新規で住所を入力した後、確認画面に進むを押すと注文確認画面に遷移する' do
        expect(current_path).to eq '/orders/confirm'
      end
    end
    describe '注文確認画面のテスト' do
      it '選択した商品、合計金額、配送方法などが表示されている' do
        expect(page).to have_content product.name
        expect(page).to have_content '銀行振込'
        tax_included_price = product.price * 1.1
        tax_included_price = tax_included_price.floor
        subtotal_price = tax_included_price * cart_product.quantity
        expect(page).to have_content subtotal_price.to_s(:delimited, delimiter: ',')
      end
      it '確認ボタンを押下するとサンクスページに遷移する' do
        click_link '注文を確定する'
        expect(current_path).to eq '/orders/complete'
      end
    end
    describe 'サンクスページのテスト' do
      it 'ヘッダのマイページへのリンクを押下するとマイページに遷移する' do
        click_link '注文を確定する'
        click_link 'マイページ'
        expect(current_path).to eq '/customers/my_page'
      end
    end
    describe 'マイページのテスト' do
      it '配送先一覧へのリンクを押下すると配送先一覧画面に遷移する' do
        click_link '注文を確定する'
        click_link 'マイページ'
        click_link '一覧を見る', match: :first
        expect(current_path).to eq '/addresses'
      end
    end
    describe '住所一覧画面のテスト' do
      it '先程入力した住所が表示されている' do
        click_link '注文を確定する'
        click_link 'マイページ'
        click_link '一覧を見る', match: :first
        expect(page).to have_content "1234567"
        expect(page).to have_content "東京都渋谷区代々木神園町0-0"
        expect(page).to have_content "令和道子"
      end
      
describe '④登録情報変更～退会' do
  let(:admin) { create(:admin) }
  let(:customer) { create(:customer) }

  describe '退会のテスト' do

    describe '会員側のテスト' do
      before do
        visit new_customer_session_path
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
        visit customers_my_page_path
        click_link '編集する'
      end
      it 'URLが正しいか' do
        expect(current_path).to eq '/customers/edit'
      end

      context '退会手続のテスト' do
        before do
          click_link '退会する'
        end
        it '「退会する」を押すとアラート画面に遷移するか' do
          expect(current_path).to eq '/customers/delete_confirm'
        end
        it 'アラート画面で「退会しない」を押すとマイページに遷移するか' do
          click_link '退会しない'
          expect(current_path).to eq '/customers/my_page'
        end
        it 'アラート画面で「退会する」を押すと root_path に遷移するか' do
          click_link '退会する'
          expect(current_path).to eq '/'
        end
      end

      context '退会後のヘッダー表示の確認' do
        subject { current_path }

        before do
          click_link '退会する'
          click_link '退会する'
        end

        it 'Aboutを押すと、About画面に遷移する' do
          click_link 'About'
          is_expected.to eq '/about'
        end
        it '商品一覧を押すと、商品一覧画面に遷移する' do
          click_link '商品一覧'
          is_expected.to eq '/products'
        end
        it '新規登録を押すと、新規登録画面に遷移する' do
          click_link '新規登録'
          is_expected.to eq '/customers/sign_up'
        end
        it 'ログインを押すと、ログイン画面に遷移する' do
          click_link 'ログイン'
          is_expected.to eq '/customers/sign_in'
        end
      end

      context '退会後のログインのテスト' do
        before do
          click_link '退会する'
          click_link '退会する'
          click_link 'ログイン'
        end
        it 'URLが正しいか' do
          expect(current_path).to eq '/customers/sign_in'
        end
        it '退会したアカウントではログインできない' do
          fill_in 'customer[email]', with: customer.email
          fill_in 'customer[password]', with: customer.password
          click_button 'ログイン'
          expect(current_path).to eq '/customers/sign_in'
          expect(page).to have_content '退会済みのユーザーです。'
        end
      end
    end

    describe '管理者側のテスト' do
      let!(:customer) { create(:customer, is_deleted: true) }

      before do
        visit new_admin_session_path
        fill_in 'admin[email]', with: admin.email
        fill_in 'admin[password]', with: admin.password
        click_button 'ログイン'
      end
      it 'URLが正しいか' do
        expect(current_path).to eq '/admin/orders'
      end

      context '退会済みのユーザーが「退会」になっているか' do
        before do
          click_link '会員一覧'
        end
        it 'URLが正しいか' do
          expect(current_path).to eq '/admin/customers'
        end
        it '会員一覧に「退会」の表示が出ているか' do
          expect(page).to have_content '退会'
        end
        it '会員名を押すと会員詳細画面に推移し、会員ステータスが「退会」になっている' do
          click_link customer.last_name + customer.first_name
          expect(current_path).to eq('/admin/customers/' + customer.id.to_s)
          expect(page).to have_content '退会'
        end
        it 'ログアウト後の遷移先は admin/sing_in であるか' do
          click_link 'ログアウト'
          expect(current_path).to eq('/admin/sign_in')
        end
      end
    end
  end

  describe '住所変更のテスト' do
    it '会員が変更した住所を管理者側から確認する' do
      # 会員ページにログインして会員情報を変更
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      visit edit_customers_path
      gimei = Gimei::Name.new
      fill_in 'customer[last_name]', with: gimei.last.kanji
      fill_in 'customer[first_name]', with: gimei.first.kanji
      fill_in 'customer[last_name_kana]', with: gimei.last.katakana
      fill_in 'customer[first_name_kana]', with: gimei.first.katakana
      fill_in 'customer[postcode]', with: Faker::Number.number(digits: 7)
      fill_in 'customer[address]', with: Gimei.address.kanji
      fill_in 'customer[email]', with: Faker::Internet.email
      click_button '編集内容を保存'
      click_link 'ログアウト'
      # 管理者側で会員情報の変更内容を確認
      visit new_admin_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      visit admin_customer_path(customer)
      # 変更前の会員情報が記載されていないことを確認
      expect(page).not_to have_content customer.last_name
      expect(page).not_to have_content customer.first_name
      expect(page).not_to have_content customer.last_name_kana
      expect(page).not_to have_content customer.first_name_kana
      expect(page).not_to have_content customer.postcode
      expect(page).not_to have_content customer.address
      expect(page).not_to have_content customer.email
      # 変更後の会員情報が記載されていることを確認
      expect(page).to have_content customer.reload.last_name
      expect(page).to have_content customer.reload.first_name
      expect(page).to have_content customer.reload.last_name_kana
      expect(page).to have_content customer.reload.first_name_kana
      expect(page).to have_content customer.reload.postcode
      expect(page).to have_content customer.reload.address
      expect(page).to have_content customer.reload.email
    end
  end
end
