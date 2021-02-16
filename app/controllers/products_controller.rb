class ProductsController < ApplicationController
  def index
    @products = Product.where(is_active: true).order("created_at DESC").page(params[:page]).per(8)
    @active_products_all = Product.where(is_active: true)
  end

  def show
    @product = Product.find(params[:id])
    @cart_product = CartProduct.new
  end
end
