# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, "モデルに関するテスト", type: :model do
  let!(:customer) { create(:customer) }
  let!(:address) {create(:address, customer_id: customer.id) }
  it "有効な内容で実際に保存してみる" do
    expect(address).to be_valid
  end
  context "バリデーションチェック" do
    it "postcodeが空白の場合に、空白のエラーメッセージが返ってきているか" do
      address.postcode = ""
      expect(address).to be_invalid
      expect(address.errors[:postcode]).to include("を入力してください")
    end
    it "postcodeが7桁でない場合に、桁数のエラーメッセージが返ってきているか" do
      address.postcode = 1*6
      expect(address).to be_invalid
      expect(address.errors[:postcode]).to include("は7文字で入力してください")
      address.postcode = 1*8
      expect(address).to be_invalid
      expect(address.errors[:postcode]).to include("は7文字で入力してください")
    end
    
    it "addressが空白の場合に、空白のエラーメッセージが返ってきているか" do
      address.address = ""
      expect(address).to be_invalid
      expect(address.errors[:address]).to include("を入力してください")
    end
    it "dearが空白の場合に、空白のエラーメッセージが返ってきているか" do
      address.dear = ""
      expect(address).to be_invalid
      expect(address.errors[:dear]).to include("を入力してください")
    end
  end
end