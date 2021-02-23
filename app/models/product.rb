class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :price, presence: true
  belongs_to :genre
  has_many :cart_products, dependent: :destroy
  has_many :ordered_products, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  attachment :image

  # 管理者側検索メソッド
	def self.search_for(content)
	  Product.where('name LIKE?', "%#{content}%")
	end

  # 会員側検索メソッド
  def self.genre_search_for(genre)
	  where("genre_id LIKE?", "#{genre}")
  end
  
  def self.sort_for(sort)
    case sort
    when "1"
      order(created_at: "DESC")
    when "2"
      order(created_at: "ASC")
    when "3"
      order(price: "ASC")
    when "4"
      order(price: "DESC")
    when "5"
      includes(:ordered_products).sort_by {|product| product.ordered_products.size}.reverse
    end
  end

  def self.is_active_search_for(is_active)
    case is_active
    when "1"
      where(is_active: false)
    when "2"
      all
    when nil
      where(is_active: true)
    end
  end

  # ブックマーク済みか確認する
  def bookmarked_by?(customer)
    bookmarks.where(customer_id: customer.id).exists?
  end
  
end
