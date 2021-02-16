class OrderedProduct < ApplicationRecord
  belongs_to :product
  
  belongs_to :orders
  
  validates :quantity, presence: true
  validates :tax_included_price, presence: true
  validates :making_status, presence: true
  
end
