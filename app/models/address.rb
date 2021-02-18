class Address < ApplicationRecord
  belongs_to :customer
  
  validates :postcode, presence: true, length: { is: 7 }  
  validates :address,  presence: true
  validates :dear,     presence: true

end
