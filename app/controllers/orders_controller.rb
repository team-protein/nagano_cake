class OrdersController < ApplicationController
  
  def new
    @addresses = current_customer.addresses.to_a.map { |address| [address.postcode + address.address + address.dear, address.id] }
    
  end
  
  def confirm
  end
  
  def create
  end
  
  def complete
  end
  
  def index
  end
  
  def show
  end
end
