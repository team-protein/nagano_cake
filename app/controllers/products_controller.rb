class ProductsController < ApplicationController
  
  def index
    if params[:words].present?
      words = params[:words].split(/[[:blank:]]+/).select(&:present?)
      @products = Product.none
      words.each do |word|
        if word.match(/[一-龠々]/)
          conversion_word = word.to_kanhira.to_roman
        elsif word.is_hira? || word.is_kana?
          conversion_word = word.to_roman
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
    @product_names = Product.where(is_active: true).pluck(:name).push(",")
    @product_names_hira = @product_names.map do |name|
      if name.match(/[一-龠々]/)
        name.to_s.to_kanhira
      elsif name.is_kana?
        name.to_hira
      else
        name
      end
    end
  end

  def show
    @product = Product.find(params[:id])
    @cart_product = CartProduct.new
  end
end
