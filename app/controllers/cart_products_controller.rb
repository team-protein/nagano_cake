class CartProductsController < ApplicationController
  before_action :authenticate_customer!

  def create
    cart_product = CartProduct.new(cart_product_params)
    cart_product.customer_id = current_customer.id
    cart_product.save
    redirect_to cart_products_path
  end

  def index
    @cart_products = current_customer.cart_products
  end

  def update
    cart_product = CartProduct.find(params[:id])
    cart_product.update(cart_product_params)
    redirect_to cart_products_path
  end

  def destroy
    CartProduct.find(params[:id]).destroy
    redirect_to cart_products_path
  end

  def destroy_all
    CartProduct.where(customer_id: current_customer.id).destroy_all
    redirect_to cart_products_path
  end

  private
    def cart_product_params
      params.require(:cart_product).permit(:customer_id, :product_id, :quantity)
    end
end
