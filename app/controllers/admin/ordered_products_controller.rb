class Admin::OrderedProductsController < ApplicationController
  before_action :authenticate_admin!
  
  def update
    @order = Order.find(params[:order_id])
    @ordered_product = OrderedProduct.find(params[:id])
    @ordered_product.update(making_status: params[:making_status])
    if @ordered_product.making_status == "working" && @order.status == "入金確認"
      @order.status = "製作中"
    elsif @order.ordered_products.where(making_status: "completed").count == @order.ordered_products.count
      @order.status = "発送準備中"
    end
      redirect_to admin_order_path(@order)
  end
  
end
