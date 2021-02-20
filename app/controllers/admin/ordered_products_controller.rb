class Admin::OrderedProductsController < ApplicationController
  before_action :authenticate_admin!
  
  def update
    @order = Order.find(params[:order_id])
    @ordered_product = OrderedProduct.find(params[:id])
    @ordered_product.update(making_status: params[:making_status])
    if @ordered_product.making_status == "working" && @order.status == "payment_confirm"
      @order.status = "working"
    elsif @order.ordered_products.where(making_status: "completed").count == @order.ordered_products.count
      @order.status = "shipping_preparing"
    end
    @order.save
      redirect_to admin_order_path(@order)
  end
  
end
