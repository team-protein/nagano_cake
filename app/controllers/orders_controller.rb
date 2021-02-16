class OrdersController < ApplicationController
  
  def new
    @addresses = current_customer.addresses.to_a.map { |address| [address.postcode + address.address + address.dear, address.id] }
  end
  
  def confirm
  end
  
  def create
    order = current_customer.orders.new(payment_method: params[:payment_method])
    if params[:shipping_method] == 0
      order.postcode = current_customer.postcode
      order.address = current_customer.address
      order.dear = current_customer.last_name + current_customer.first_name
    elsif params[:shipping_method] == 1
      address = Address.find(params[:address_id])
      order.postcode = address.postcode
      order.address = address.address
      order.dear = address.dear
    else 
      order.postcode = params[:postcode]
      order.address = params[:address]
      order.dear = params[:dear]
    end
    order.save
    redirect_to orders_confirm_path(order)
  end
  
  def complete
  end
  
  def index
  end
  
  def show
  end
end
