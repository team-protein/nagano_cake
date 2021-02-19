class Order < ApplicationRecord
  belongs_to :customer
  has_many :ordered_products
  
  enum payment_method: {
    credit: 0, #クレジットカード
    bank: 1, #銀行振込
  }
  enum status: {
    payment_waiting: 0, #入金待ち
    payment_confirm: 1, #入金確認
    working: 2, #製作中
    shipping_preparing: 3, #発送準備中
    shipping_complete: 4 #発送完了
  }

  
  validates :postcode, presence: true, length: { is: 7 }  
  validates :address, presence: true
  validates :dear, presence: true

end
