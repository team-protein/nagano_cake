class CartProductsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @cart_product = CartProduct.new(cart_product_params)
    @cart_product.customer_id = current_customer.id
    if current_customer.cart_products.find_by(product_id: params[:cart_product][:product_id]).present?
      if params[:cart_product][:quantity] == ""
        @product = @cart_product.product
        flash.now[:alert] = '個数を入力してください'
        render 'products/show'
      else
        @cart_product = current_customer.cart_products.find_by(product_id: params[:cart_product][:product_id])
        @cart_product.quantity += params[:cart_product][:quantity].to_i
        @cart_product.save
        flash[:notice] = "商品をカートに追加しました。"
        redirect_to cart_products_path
      end
    elsif @cart_product.save
      flash[:notice] = "新たな商品をカートに追加しました。"
      redirect_to cart_products_path
    else
      @product = @cart_product.product
      flash.now[:alert] = '個数を入力してください'
      render 'products/show'
    end
  end

  def index
    @cart_products = current_customer.cart_products
    @total_price = @cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity}
  end

  def update
    @cart_product = CartProduct.find(params[:id])
    if @cart_product.update(cart_product_params)
      @cart_products = CartProduct.where(customer_id: current_customer.id)
      @total_price = @cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity}
    else
      render 'update_error'
    end
  end

  def destroy
    @cart_product = CartProduct.find(params[:id])
    @cart_product.destroy
    @cart_products = CartProduct.where(customer_id: current_customer.id)
    @total_price = @cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity}
  end

  def destroy_all
    @cart_products = CartProduct.where(customer_id: current_customer.id)
    @cart_products.destroy_all
    @total_price = 0
  end

  private
    def cart_product_params
      params.require(:cart_product).permit(:customer_id, :product_id, :quantity)
    end
end