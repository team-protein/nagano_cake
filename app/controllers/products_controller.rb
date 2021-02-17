class ProductsController < ApplicationController
  def index
    @products = Product.where(is_active: true)
    if params[:word].present?
      @products = @products.name_search_for(params[:word])
    end
    if params[:genre_id].present?
      @genre = Genre.find(params[:genre_id])
      @products = @products.genre_search_for(params[:genre_id])
    end
    @products_count = @products.count
    @products = @products.page(params[:page]).per(8)
  end

  def show
    @product = Product.find(params[:id])
    @cart_product = CartProduct.new
  end
end
