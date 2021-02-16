class Order < ApplicationRecord
  belongs_to :customer
  
  has_many :ordered_products
  
  enum payment_method: { クレジットカード: 0, 銀行振込: 1}
  enum status: {入金待ち:0, 入金確認: 1,}
end
