require 'rails_helper'

describe 'ログイン前のテスト' do
  before do
    visit root_path
  end

  describe '新規登録のテスト' do
    it 'トップページで新規登録画面へのリンクを押下すると新規登録画面が表示される' do
      click_link '新規登録'
      expect(current_path).to eq '/customers/sign_up'
    end
    context '新規登録成功後のテスト' do
      before do
        visit new_customer_registration_path
        gimei = Gimei::Name.new
        fill_in 'customer[last_name]', with: gimei.last.kanji
        fill_in 'customer[first_name]', with: gimei.first.kanji
        fill_in 'customer[last_name_kana]', with: gimei.last.katakana
        fill_in 'customer[first_name_kana]', with: gimei.first.katakana
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[phone_number]', with: Faker::PhoneNumber.phone_number
        fill_in 'customer[postcode]', with: Faker::Number.number(digits: 7)
        fill_in 'customer[address]', with: Gimei.address.kanji
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end
      it '新規登録後、トップ画面へ遷移する' do
        click_button '新規登録'
        expect(current_path).to eq '/customers/my_page'
      end
      context '新規登録後、ヘッダがログイン後の表示に変わっている' do
        before do
          click_button '新規登録'
        end
        it '「マイページ」と表示される' do
          expect(page).to have_link 'マイページ'
        end
        it '「商品一覧」と表示される' do
          expect(page).to have_link'商品一覧'
        end
        it '「カート」と表示される' do
          expect(page).to have_link 'カート'
        end
        it '「ログアウト」と表示される' do
          expect(page).to have_link 'ログアウト'
        end
      end
    end

  end

end
describe 'ログイン後のテスト：登録～注文' do
  let(:customer) { create(:customer) }
  let!(:genre) { create(:genre) }
  let!(:product) { create(:product, genre_id: genre.id) }
  let!(:cart_product) { create(:cart_product, product_id: product.id, customer_id: customer.id) }
  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end
  describe '商品一覧ページのテスト' do
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
  describe '商品詳細ページのテスト' do
    context '個数を選択し、カートに入れるボタンを押下したとき' do
      it 'カート画面に遷移する' do
        visit product_path(product.id)
        select rand(1..10), from: 'cart_product_quantity'
        click_button 'カートに入れる'
        expect(current_path).to eq '/cart_products'
      end
      it 'カートの中身が正しく表示されている' do
        visit cart_products_path
        expect(page).to have_content product.name
        expect(page).to have_field 'cart_product[quantity]', with: cart_product.quantity
        tax_included_price = product.price * 1.1
        tax_included_price = tax_included_price.floor
        subtotal_price = tax_included_price * cart_product.quantity
        expect(page).to have_content subtotal_price.to_s(:delimited, delimiter: ',')
      end
    end
  end
  describe 'カート画面のテスト' do
    before do
      visit cart_products_path
    end
    it '買い物を続けるボタンを押下したとき、商品一覧ページに遷移する' do
      click_link '買い物を続ける'
      expect(current_path).to eq '/products'
    end
    it '商品の個数を変更し、更新ボタンを押下すると表示が正しく更新される' do
      new_quantity = rand(1..10)
      select new_quantity, from: 'cart_product_quantity'
      click_on '変更'
      using_wait_time 5 do
        visit current_path
        expect(page).to have_select(id="cart_product_quantity", selected: new_quantity.to_s)
        tax_included_price = product.price * 1.1
        tax_included_price = tax_included_price.floor
        subtotal_price = tax_included_price * new_quantity
        expect(page).to have_content subtotal_price.to_s(:delimited, delimiter: ',')
      end
    end
    it '情報入力に進むボタンを押下したとき、情報入力画面に遷移する' do
      click_link '情報入力に進む'
      expect(current_path).to eq '/orders/new'
    end
  end
  describe '注文情報入力画面のテスト' do
    it '支払方法を選択、登録済みの自分の住所を選択した後、確認画面に進むを押すと注文確認画面に遷移する' do
      visit new_order_path
      choose 'payment_method_bank'
      choose 'shipping_to_0'
      click_button '確認画面へ進む'
      expect(current_path).to eq '/orders/confirm'
    end
  end
  describe '注文確認画面のテスト' do
    it '選択した商品、合計金額、配送方法などが表示されている' do
      visit new_order_path
      choose 'payment_method_bank'
      click_button '確認画面へ進む'
      expect(page).to have_content product.name
      expect(page).to have_content '銀行振込'
      tax_included_price = product.price * 1.1
      tax_included_price = tax_included_price.floor
      subtotal_price = tax_included_price * cart_product.quantity
      expect(page).to have_content subtotal_price.to_s(:delimited, delimiter: ',')
    end
    it '注文を確定するを押すとサンクスページに遷移する' do
      visit new_order_path
      click_button '確認画面へ進む'
      click_link '注文を確定する'
      expect(current_path).to eq '/orders/complete'
    end
  end
  describe 'マイページのテスト' do
    it '注文履歴へのリンクを押下すると注文履歴一覧画面が表示される' do
      visit customers_my_page_path
      page.all(".btn-primary")[1].click
      expect(current_path).to eq '/orders'
    end
  end
  describe '注文履歴一覧画面のテスト' do
    let!(:order) { create(:order, customer_id: customer.id) }
    it '注文の詳細表示ボタンを押下すると注文詳細画面が表示される' do
      visit orders_path
      click_on '表示する', match: :first
      expect(current_path).to eq '/orders/'  + order.id.to_s
    end
  end
  describe '注文履歴詳細画面のテスト' do
    let!(:order) { create(:order, customer_id: customer.id) }
    let!(:ordered_product) { create(:ordered_product, order_id: order.id, product_id: product.id, quantity: cart_product.quantity) }
      it '注文内容が正しく表示されている' do
        visit order_path(order)
        expect(page).to have_content product.name
        expect(page).to have_content order.payment_method_i18n
        tax_included_price = ordered_product.product.price * 1.1
        tax_included_price = tax_included_price.floor
        subtotal_price = tax_included_price * ordered_product.quantity
        expect(page).to have_content subtotal_price.to_s(:delimited, delimiter: ',')
      end
      it 'ステータスが「入金待ち」になっている' do
        visit order_path(order)
        expect(page).to have_content '入金待ち'
      end
  end
end