class CartProductsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @cart_product = CartProduct.new(cart_product_params)
    @cart_product.customer_id = current_customer.id
    if current_customer.cart_products.find_by(product_id: params[:cart_product][:product_id]).present?
      @cart_product = current_customer.cart_products.find_by(product_id: params[:cart_product][:product_id])
      @cart_product.quantity += params[:cart_product][:quantity].to_i
      @cart_product.save
      flash[:notice] = "Product was successfully added to cart."
      redirect_to cart_products_path
    else @cart_product.save
      flash[:notice] = "New product was successfully added to cart."
      redirect_to cart_products_path
    end
  end

  def index
    @cart_products = current_customer.cart_products
    @total_price = @cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity}
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