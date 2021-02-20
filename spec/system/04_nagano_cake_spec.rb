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
    end
  end
end
