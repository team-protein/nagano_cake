class OrderedProduct < ApplicationRecord
  belongs_to :product
  belongs_to :orders
  
  validates :quantity, presence: true
  validates :tax_included_price, presence: true
  validates :making_status, presence: true
  

  enum making_status: {
    impossible: 0, #製作不可
    waiting: 1, #製作待ち
    working: 2, #製作中
    completed: 3, #製作完了
  }
end
