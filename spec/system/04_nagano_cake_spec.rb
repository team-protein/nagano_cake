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