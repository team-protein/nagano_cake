class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :price, presence: true
  belongs_to :genre
  attachment :image
end
