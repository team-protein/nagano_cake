class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
    @tax_included_price = @product.price * 1.1
  end
end
