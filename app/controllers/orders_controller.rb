class OrdersController < ApplicationController

  def complete
  end
  
  def confirm
  end
  
  def index
  end
  
  def new
    @order = Order.new
    @addresses = current_customer.addresses.to_a
    @shipping_addresses = @addresses.map { |address| [address.postcode + address.address + address.dear, address.id] }
  end
   
  def show
  end

end
