# frozen_string_literal: true

require 'rails_helper'

describe '①マスタ登録のテスト' do
  
    describe 'ログイン前のテスト' do
      let!(:admin) { create(:admin) }
      it "1.メールアドレス、パスワードでログインし、管理者トップ画面が表示される" do
      visit new_admin_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      expect(page).to have_content "ログインしました"
      expect(current_path).to eq '/admin/orders'
      end
    end
    
    describe 'ログイン後のテスト' do
      let!(:admin) { create(:admin) }
      before do
        visit new_admin_session_path
        fill_in 'admin[email]', with: admin.email
        fill_in 'admin[password]', with: admin.password
        click_button 'ログイン'
        Genre.create(name: "ケーキ")
        Genre.create(name: "プリン")
        Genre.create(name: "焼き菓子")
        Genre.create(name: "キャンディ")
        Genre.create(name: "アイスクリーム")
      end
      context "管理者トップ画面のテスト" do
        it "2.ヘッダからジャンル一覧へのリンクを押下し、ジャンル一覧画面が表示される" do
          click_on 'ジャンル一覧'
          expect(current_path).to eq '/admin/genres'
        end
      end
      context 'ジャンル一覧画面のテスト' do
        it "3.必要事項を入力し、登録ボタンを押下し、追加したジャンルが表示されている" do
          click_link 'ジャンル一覧'
          fill_in 'genre[name]', with: "ジャンルテスト"
          click_button '新規登録'
          expect(page).to have_content "ジャンルテスト"
        end
        it '4.ヘッダから商品一覧へのリンクを押下し、商品一覧画面が表示される' do
          click_on 'ジャンル一覧'
          click_on '商品一覧'
          expect(current_path).to eq '/admin/products'
        end
      end
      context '商品新規登録のテスト' do
        it "5.新規登録ボタンを押下し、新規登録画面が表示される" do
          click_on '商品一覧'
          click_on '＋'
          expect(current_path).to eq '/admin/products/new'
        end
        it "6~8.必要事項を入力して登録ボタンを押下し、登録した商品の詳細画面に遷移する。その後、商品一覧画面へ遷移し、登録した商品が表示されている。" do
          click_on '商品一覧'
          click_on '＋'
          fill_in 'product[name]', with: "テストスペシャルショートケーキ"
          fill_in 'product[description]', with: "特別なショートケーキでとても美味しいです。"
          select "ケーキ", from: 'product_genre_id'
          fill_in 'product[price]', with: "3000"
          choose 'product_is_active_true'
          click_on '新規登録'
          expect(page).to have_content "テストスペシャルショートケーキ"
          click_on '商品一覧'
          expect(current_path).to eq '/admin/products'
          expect(page).to have_content "テストスペシャルショートケーキ"
        end
      end
      context '商品新規登録2回目のテスト' do
        before '商品新規登録1回目の作業' do
          click_on '商品一覧'
          click_on '＋'
          fill_in 'product[name]', with: "テストスペシャルショートケーキ"
          fill_in 'product[description]', with: "特別なショートケーキでとても美味しいです。"
          select 'ケーキ', from: 'product_genre_id'
          fill_in 'product[price]', with: "3000"
          choose 'product_is_active_true'
          click_on '新規登録'
          expect(page).to have_content "テストスペシャルショートケーキ"
          click_on '商品一覧'
          expect(current_path).to eq '/admin/products'
          expect(page).to have_content "テストスペシャルショートケーキ"
        end
        it "9~12.必要事項を入力して登録ボタンを押下し、登録した商品の詳細画面に遷移する。その後、商品一覧画面へ遷移し、登録した商品が表示されている(2回目)" do
          click_on '＋'
          expect(current_path).to eq ('/admin/products/new')
          fill_in 'product[name]', with: "テストスペシャルクッキー"
          fill_in 'product[description]', with: "特別なクッキーでとても美味しいです。"
          select '焼き菓子', from: "product_genre_id"
          fill_in 'product[price]', with: "600"
          choose 'product_is_active_true'
          click_on '新規登録'
          expect(page).to have_content "テストスペシャルクッキー"
          click_on '商品一覧'
          expect(current_path).to eq '/admin/products'
          expect(page).to have_content "テストスペシャルクッキー"
        end
      end
      it "10.ヘッダからログアウトボタンをクリックすると、管理者ログインページに遷移する" do
        click_on 'ログアウト'
        expect(page).to have_content "ログアウトしました"
        expect(current_path). to eq '/admin/sign_in'
      end
    end
end