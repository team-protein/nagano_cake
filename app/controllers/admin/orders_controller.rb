class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:user_id].present?
      customer = Customer.find(params[:user_id])
      @orders = customer.orders.page(params[:page]).per(10)
    else
      @orders = Order.page(params[:page]).per(10)
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(status: params[:status])
    if @order.status == "payment_confirm"
      @order.ordered_products.map do |o_product|
        o_product.making_status = "waiting"
        o_product.save
      end
    end
    redirect_to admin_order_path(@order)
  end
end
