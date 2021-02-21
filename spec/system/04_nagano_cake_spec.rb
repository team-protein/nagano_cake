# frozen_string_literal: true

require 'rails_helper'

describe "④登録情報変更〜退会1~15のテスト" do
  let!(:customer) { create(:customer) }
  before do
    visit new_customer_session_path
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
    expect(page).to have_content "ログインしました"
    expect(current_path).to eq '/'
  end
  context '会員情報変更のテスト' do
    it "1.マイページにて会員情報編集ボタンを押下し、会員情報編集画面に遷移する" do
    click_on 'マイページ'
    expect(current_path).to eq '/customers/my_page'
    click_on '編集する'
    expect(current_path).to eq '/customers/edit'
    end
    it "2~3.会員情報編集画面にて全項目を編集し、マイページにて変更した内容が表示される" do
      click_on 'マイページ'
      expect(current_path).to eq '/customers/my_page'
      click_on '編集する'
      expect(current_path).to eq '/customers/edit'
      fill_in 'customer_last_name', with: 'テスト田'
      fill_in 'customer_first_name', with: 'テスト太郎'
      fill_in 'customer_last_name_kana', with: 'テストダ'
      fill_in 'customer_first_name_kana', with: 'テストタロウ'
      fill_in 'postcode-form', with: '1111111'
      fill_in 'address-form', with: 'テスト県テスト市テスト区テスト町'
      fill_in 'customer_phone_number', with: '00000000000'
      fill_in 'customer_email', with: 'test@test.com'
      click_on '編集内容を保存'
      expect(current_path).to eq '/customers/my_page'
      expect(page).to have_content "テスト田"
      expect(page).to have_content "テスト太郎"
      expect(page).to have_content "テストダ"
      expect(page).to have_content "テストタロウ"
      expect(page).to have_content "1111111"
      expect(page).to have_content "テスト県テスト市テスト区テスト町"
      expect(page).to have_content "00000000000"
      expect(page).to have_content "テスト田"
    end
  end
  context '配送先登録のテスト' do
    it "4.マイページにて配送先一覧ボタンを押下し、配送先一覧画面に遷移する" do
      click_on 'マイページ'
      expect(current_path).to eq '/customers/my_page'
      find_all('.btn-primary')[0].click
      expect(current_path). to eq '/addresses'
    end
    it '5~6. 配送先一覧画面にて各項目を登録した後、画面が再描画され、登録した内容が表示される' do
      click_on 'マイページ'
      expect(current_path).to eq '/customers/my_page'
      click_on '一覧を見る', match: :first
      expect(current_path).to eq '/addresses'
      fill_in 'postcode-form', with: '2222222'
      fill_in 'address-form', with: 'テストアドレス県テストアドレス市'
      fill_in 'address_dear', with: 'アドレス田 アドレス太郎'
      click_on '新規登録'
      expect(current_path).to eq '/addresses'
      expect(page).to have_content "2222222"
      expect(page).to have_content "テストアドレス県テストアドレス市"
      expect(page).to have_content "アドレス田 アドレス太郎"
    end
  end
  context 'トップ画面のテスト' do
    it '7.ヘッダからトップ画面へのリンクをクリックし、トップ画面へ遷移する' do
      find_all('.navbar-brand')[0].click
      expect(current_path).to eq '/'
    end
    it '8~9.トップ画面にて任意の商品画像を押下すると、該当商品の詳細画面に遷移し、商品情報が正しく表示されている' do
      genre = FactoryBot.create(:genre)
      3.downto(0) do |count|
      FactoryBot.create(:product, name: "テストプロダクト#{count}", genre_id: genre.id)
      end
      find_all('.navbar-brand')[0].click
      product_num = rand(0..3)
      selected_product = Product.find_by(name: "テストプロダクト#{product_num}")
      find_all('.product_image')[product_num].click
      expect(page).to have_content "テストプロダクト#{product_num}"
      expect(current_path). to eq "/products/#{selected_product.id}"
    end
  end
  context '注文のテスト' do
    it '10~11.個数を選択し、カートに入れるボタンを押下し、カートの中身が正しく表示されている' do
      3.downto(0) do |count|
      FactoryBot.create(:product, name: "テストプロダクト#{count}")
      end
      find_all('.navbar-brand')[0].click
      product_num = rand(0..3)
      find_all('.product_image')[product_num].click
      selected_product = Product.find_by(name: "テストプロダクト#{product_num}")
      expect(current_path). to eq "/products/#{selected_product.id}"
      quantity = rand(1..100)
      fill_in 'cart_product_quantity', with: quantity
      click_on 'カートに入れる'
      kakaku = (selected_product.price * 1.1).floor
      total_kakaku = kakaku * quantity
      expect(page).to have_content "#{selected_product.name}"
      expect(page).to have_content "#{kakaku.to_s(:delimited, delimiter: ',')}"
      expect(find('#cart_product_quantity').value).to eq "#{quantity}"
      expect(page).to have_content "#{total_kakaku.to_s(:delimited, delimiter: ',')}"
    end
    it '12.カート画面にて次に進むボタンを押下後、情報入力画面に遷移する' do
      3.downto(0) do |count|
      FactoryBot.create(:product, name: "テストプロダクト#{count}")
      end
      find_all('.navbar-brand')[0].click
      product_num = rand(0..3)
      find_all('.product_image')[product_num].click
      selected_product = Product.find_by(name: "テストプロダクト#{product_num}")
      expect(current_path). to eq "/products/#{selected_product.id}"
      quantity = rand(1..100)
      fill_in 'cart_product_quantity', with: quantity
      click_on 'カートに入れる'
      click_on '情報入力に進む'
      expect(current_path).to eq "/orders/new"
    end
    it '13~14.注文情報画面にて、登録した住所を選択の上、購入ボタンを押下し、サンクスページに遷移する' do
      click_on 'マイページ'
      expect(current_path).to eq '/customers/my_page'
      click_on '一覧を見る', match: :first
      expect(current_path).to eq '/addresses'
      fill_in 'postcode-form', with: '2222222'
      fill_in 'address-form', with: 'テストアドレス県テストアドレス市'
      fill_in 'address_dear', with: 'アドレス田 アドレス太郎'
      click_on '新規登録'
      expect(current_path).to eq '/addresses'
      expect(page).to have_content "2222222"
      expect(page).to have_content "テストアドレス県テストアドレス市"
      expect(page).to have_content "アドレス田 アドレス太郎"
      3.downto(0) do |count|
      FactoryBot.create(:product, name: "テストプロダクト#{count}")
      end
      find_all('.navbar-brand')[0].click
      product_num = rand(0..3)
      find_all('.product_image')[product_num].click
      selected_product = Product.find_by(name: "テストプロダクト#{product_num}")
      expect(current_path). to eq "/products/#{selected_product.id}"
      quantity = rand(1..100)
      fill_in 'cart_product_quantity', with: quantity
      click_on 'カートに入れる'
      click_on '情報入力に進む'
      expect(current_path).to eq "/orders/new"
      choose 'shipping_to_1'
      select "〒2222222 テストアドレス県テストアドレス市 アドレス田 アドレス太郎", from: "address_id"
      payment_method = ["payment_method_credit", "payment_method_bank"]
      choose "#{payment_method[rand(0..1)]}"
      click_on '確認画面へ進む'
      expect(current_path).to eq '/orders/confirm'
      click_on '注文を確定する'
      expect(current_path).to eq '/orders/complete'
    end
    it '15.サンクスページにてヘッダのトップリンクをクリックし、トップ画面が表示される' do
      find_all('.navbar-brand')[0].click
      expect(current_path).to eq '/'
    end
  end
end

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
