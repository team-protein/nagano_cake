class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 200 }
  validates :price, presence: true
  belongs_to :genre
  has_many :cart_products, dependent: :destroy
  attachment :image

  # 管理者側検索用メソッド
	def self.search_for(content)
	  Product.where('name LIKE?', "%#{content}%")
	end

  # 会員側検索用メソッド
  def self.genre_search_for(content, genre)
	  Product.where(is_active: true).where("name LIKE? AND genre_id LIKE?", "%#{content}%", "#{genre}")
	  # genre_ids = Product.where("genre_id = ?").pluck(:id)
    # @submit_searched = Product.where("submit_id IN (?) or submit_id IN (?)", submit_name_ids, problem_name_ids)
    # #submit_name_idsかproblem_name_idsに当てはまるものをsubmitテーブルから探して、
    # #@submit_searchedに代入。
    # Classmate.where(class_id: 2).where(club_name: 'tennis')
  end
end
