require 'rails_helper'

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
      let(:admin) { create(:admin) }
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

  end
end