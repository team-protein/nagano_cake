class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :price, presence: true
  belongs_to :genre
  has_many :cart_products, dependent: :destroy
  attachment :image

  # 検索用メソッド
	def self.search_for(content)
	  	Product.where('name LIKE?', "%#{content}%")
	end
end
