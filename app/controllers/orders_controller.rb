class OrdersController < ApplicationController

  def new
    unless current_customer.cart_products.present?
      flash.now[:alert] = "商品をカートに入れてください"
      @cart_products = current_customer.cart_products
      @total_price = @cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity}
      render "cart_products/index"
    end
    @addresses = current_customer.addresses.to_a.map {|address| ["〒#{address.postcode} #{address.address} #{address.dear}", address.id]}
  end

  def confirm
    @order = current_customer.orders.new(payment_method: params[:payment_method])
    # お届け先：ご自身の住所
    if params[:shipping_to] == "0"
      @order.postcode = current_customer.postcode
      @order.address = current_customer.address
      @order.dear = current_customer.last_name + current_customer.first_name
    # お届け先：登録済み住所から選択
    elsif params[:shipping_to] == "1"
      address = Address.find(params[:address_id])
      @order.postcode = address.postcode
      @order.address = address.address
      @order.dear = address.dear
    else
    # お届け先：新しいお届け先
      @order.postcode = params[:postcode]
      @order.address = params[:address]
      @order.dear = params[:dear]
    end
    @order.shipping_cost = 800
    @order.total_price = current_customer.cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity} + @order.shipping_cost
    @ordered_products_sum = @order.total_price - @order.shipping_cost
    session[:order] = @order
    session[:postcode] = params[:postcode]
    session[:address] = params[:address]
    session[:dear] = params[:dear]
    render :new if @order.invalid?
  end

  def create
    @order = current_customer.orders.new(session[:order])
    session[:order] = nil
    if @order.save
      current_customer.cart_products.each do |cart_product|
        ordered_product = @order.ordered_products.new
        ordered_product.product_id = cart_product.product.id
        ordered_product.quantity = cart_product.quantity
        ordered_product.tax_included_price = cart_product.product.price * 1.1 
        ordered_product.save
      end
      current_customer.addresses.create(postcode: session[:postcode], address: session[:address], dear: session[:dear])
      session[:postcode] = nil
      session[:address] = nil
      session[:dear] = nil
      current_customer.cart_products.destroy_all
      redirect_to complete_orders_path
    else
      render :new
    end

  end

  def complete
  end

  def index
  end

  def show
    @order = Order.find(params[:id])
    @ordered_products_sum = @order.total_price - @order.shipping_cost
  end

end
