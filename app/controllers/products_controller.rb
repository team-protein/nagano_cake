class ProductsController < ApplicationController

  def index
    if params[:words].present?
      words = params[:words].split(/[[:blank:]]+/).select(&:present?)# 検索ワードを空白がある場所で区切って新しい配列を作る

      @products = Product.none #エラーが出ないように空の配列を作る
      words.each do |word|
        if word.match(/[一-龠々]/) #漢字が含まれているとき
          word = word.gsub(/[0-9]/, "") #数字を削除する
          word = word.gsub(/[０-９]/, "")
          conversion_word = word.to_kanhira
        elsif word.is_kana? #カタカナのとき
          conversion_word = word.to_hira
        else
          conversion_word = word
        end
        @products = @products.or(Product.where("conversion_name LIKE ?", "%#{conversion_word}%"))
      end
    else
      @products = Product.all
    end
    if params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      @products = @products.genre_search_for(params[:genre_id])
    end
    if params[:min_price].present?
      @products = @products.where(price: params[:min_price].to_i..Float::INFINITY)
    end
    if params[:max_price].present?
      @products = @products.where(price: 0..params[:max_price].to_i)
    end
    if params[:is_active].present?
      @products = @products.is_active_search_for(params[:is_active])
    else
      @products = @products.where(is_active: true)
    end
    if params[:sort].present?
      @products = @products.sort_for(params[:sort])
    else
      @products = @products.order(created_at: "DESC")
    end
    @products_count = @products.count
    @products = Kaminari.paginate_array(@products).page(params[:page]).per(8)
  end

  def show
    @product = Product.find(params[:id])
    @cart_product = CartProduct.new
  end
end
