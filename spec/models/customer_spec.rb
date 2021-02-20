# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, "モデルに関するテスト", type: :model do
  it "有効な内容で実際に保存してみる" do
    expect(FactoryBot.build(:customer)).to be_valid
  end
  context "バリデーションチェック" do
    it "last_nameが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, last_name: "")
      expect(customer).to be_invalid
      expect(customer.errors[:last_name]).to include("を入力してください")
    end
    it "first_nameが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, first_name: "")
      expect(customer).to be_invalid
      expect(customer.errors[:first_name]).to include("を入力してください")
    end
    it "last_name_kanaが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, last_name_kana: "")
      expect(customer).to be_invalid
      expect(customer.errors[:last_name_kana]).to include("を入力してください")
    end
    it "first_name_kanaが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, first_name_kana: "")
      expect(customer).to be_invalid
      expect(customer.errors[:first_name_kana]).to include("を入力してください")
    end
    it "emailが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, email: "")
      expect(customer).to be_invalid
      expect(customer.errors[:email]).to include("を入力してください")
    end
    it "phone_numberが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, phone_number: "")
      expect(customer).to be_invalid
      expect(customer.errors[:phone_number]).to include("を入力してください")
    end
    it "pastcodeが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, postcode: "")
      expect(customer).to be_invalid
      expect(customer.errors[:postcode]).to include("を入力してください")
    end
    it "pastcodeが7桁でない場合に、桁数のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, postcode: "1"*6)
      expect(customer).to be_invalid
      expect(customer.errors[:postcode]).to include("は7文字で入力してください")
      customer1 = FactoryBot.build(:customer, postcode: "1"*8)
      expect(customer1).to be_invalid
      expect(customer.errors[:postcode]).to include("は7文字で入力してください")
    end
    it "addressが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, address: "")
      expect(customer).to be_invalid
      expect(customer.errors[:address]).to include("を入力してください")
    end
    it "passwordが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, password: "")
      expect(customer).to be_invalid
      expect(customer.errors[:password]).to include("を入力してください")
    end
    it "password_confirmationが空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, password_confirmation: "")
      expect(customer).to be_invalid
      expect(customer.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
    it "passwordとpassword_confirmationが両方空白の場合に、空白のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, password: "", password_confirmation: "")
      expect(customer).to be_invalid
      expect(customer.errors[:password]).to include("を入力してください")
    end
    it "passwordとpassword_confirmationが6文字未満の場合に、文字数のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, password: "a"*5, password_confirmation: "a"*5)
      expect(customer).to be_invalid
      expect(customer.errors[:password]).to include("は6文字以上で入力してください")
    end
    it "passwordとpassword_confirmationが一致しない場合に、不一致のエラーメッセージが返ってきているか" do
      customer = FactoryBot.build(:customer, password: "a"*6, password_confirmation: "a"*10)
      expect(customer).to be_invalid
      expect(customer.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end
end