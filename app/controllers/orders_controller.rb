class OrdersController < ApplicationController

  def new
    unless current_customer.cart_products.present?
      flash[:alert] = "商品をカートに入れてください"
      render "cart_products/index"
    end
    @addresses = current_customer.addresses.to_a.map { |address| [address.postcode +  address.address +  address.dear, address.id] }
  end

  def confirm
    @order = current_customer.orders.new(payment_method: params[:payment_method])
    if params[:shipping_to] == "0"
      @order.postcode = current_customer.postcode
      @order.address = current_customer.address
      @order.dear = current_customer.last_name + current_customer.first_name
    elsif params[:shipping_to] == "1"
      address = Address.find(params[:address_id])
      @order.postcode = address.postcode
      @order.address = address.address
      @order.dear = address.dear
    else
      @order.postcode = params[:postcode]
      @order.address = params[:address]
      @order.dear = params[:dear]
    end
    session[:payment_method] = params[:payment_method]
    session[:shipping_to] = params[:shipping_to]
    session[:address_id] = params[:address_id]
    session[:postcode] = params[:postcode]
    session[:address] = params[:address]
    session[:dear] = params[:dear]
    render :new if @order.invalid?
  end

  def create
    @order = current_customer.orders.new(payment_method: session[:payment_method])
    if session[:shipping_to] == "0"
      @order.postcode = current_customer.postcode
      @order.address = current_customer.address
      @order.dear = current_customer.last_name + current_customer.first_name
    elsif session[:shipping_to] == "1"
      address = Address.find(session[:address_id])
      @order.postcode = address.postcode
      @order.address = address.address
      @order.dear = address.dear
    else
      @order.postcode = session[:postcode]
      @order.address = session[:address]
      @order.dear = session[:dear]
    end
    @order.shipping_cost = 800
    @order.total_price = current_customer.cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity} + @order.shipping_cost
    if @order.save
      current_customer.cart_products.each do |cart_product|
        ordered_product = @order.ordered_products.new
        ordered_product.product_id = cart_product.product.id
        ordered_product.quantity = cart_product.quantity
        ordered_product.tax_included_price = tax_included_price(ordered_product.product.price)
        ordered_product.save
      end
      current_customer.cart_products.destroy_all
      redirect_to complete_orders
    else
      render :new
    end

  end

  def complete
  end

  def index
  end

  def show
  end

end
