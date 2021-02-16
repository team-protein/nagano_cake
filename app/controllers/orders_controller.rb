class OrdersController < ApplicationController
  
  def new
    @addresses = current_customer.addresses.to_a.map { |address| [address.postcode +  address.address +  address.dear, address.id] }
  end
  
  def confirm
    @order = current_customer.orders.new(payment_method: params[:payment_method])
    if params[:shipping_method] == "0"
      @order.postcode = current_customer.postcode
      @order.address = current_customer.address
      @order.dear = current_customer.last_name + current_customer.first_name
    elsif params[:shipping_method] == "1"
      address = Address.find(params[:address_id])
      @order.postcode = address.postcode
      @order.address = address.address
      @order.dear = address.dear
    else 
      @order.postcode = params[:postcode]
      @order.address = params[:address]
      @order.dear = params[:dear]
    end
    @order.shipping_cost = 800
    @order.total_price = current_customer.cart_products.sum{|cart_product|cart_product.product.price * 1.1 * cart_product.quantity} + @order.shipping_cost
    return if @order.valid?
    render :new
  end
  
  def create
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
