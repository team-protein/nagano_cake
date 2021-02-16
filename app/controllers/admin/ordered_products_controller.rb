class Admin::OrderedProductsController < ApplicationController
  before_action :authenticate_admin!
  
  def update
    @order = Order.find(params[:order_id])
    @ordered_product = OrderedProduct.find(params[:id])
    request = params[:making_status]
    if request == "製作完了"
      # 未完成
      
    redirect_to admin_order_path(@order)
  end
  
end
