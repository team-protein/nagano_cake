class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    OrderedProduct.create(order_id: 1, product_id: 2, quantity: 5, tax_included_price: 2000, making_status: 0)
    OrderedProduct.create(order_id: 1, product_id: 1, quantity: 3, tax_included_price: 2000, making_status: 0)
    OrderedProduct.create(order_id: 1, product_id: 3, quantity: 4, tax_included_price: 2000, making_status: 0)
    Order.create(customer_id: 1, postcode: "35355", address: "eegdgdgdgdgdg", dear: "aaa bbbb", total_price: 35000, shipping_cost: 3200, payment_method: 1, status: 0)
    @orders = Order.all.page(params[:page]).per(10)
  end
  
  def show
    @order = Order.find(params[:id])
  end
  
end
