class Order < ApplicationRecord
  
  enum payment_method: { credit_card: 0, bank: 1 }
  enum status: { payment_waiting: 0, payment_confirm: 1, in_work: 2, delivery_preparing: 3, delivered: 4 }
  
  has_many :ordered_product, dependent: :destroy
  
  validates :postcode, presence: true
  validates :address, presence: true
  validates :dear, presence: true
  validates :total_price, presence: true
  validates :shipping_cost, presence: true
  validates :payment_method, presence: true
  validates :status, presence: true
  
end
