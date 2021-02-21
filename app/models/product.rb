class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :price, presence: true
  belongs_to :genre
  has_many :cart_products, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  attachment :image

  # 管理者側検索メソッド
	def self.search_for(content)
	  Product.where('name LIKE?', "%#{content}%")
	end

  # 会員側検索メソッド
  def self.name_search_for(content)
	  Product.where(is_active: true).where("name LIKE?", "%#{content}%")
  end

  def self.genre_search_for(genre)
	  Product.where(is_active: true).where("genre_id LIKE?", "#{genre}")
  end

  def self.name_and_genre_search_for(content, genre)
	  Product.where(is_active: true).where("name LIKE? AND genre_id LIKE?", "%#{content}%", "#{genre}")
  end

  # ブックマーク済みか確認する
  def bookmarked_by?(customer)
    bookmarks.where(customer_id: customer.id).exists?
  end
end
