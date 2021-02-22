class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:user_id].present?
      customer = Customer.find(params[:user_id])
      @orders = customer.orders.page(params[:page]).per(10)
      @orders_all = customer.orders.all.order('created_at ASC')
      order_date_sum = @orders_all.group("date(created_at)").sum(:total_price)
      @prices = order_date_sum.values
      @dates = order_date_sum.keys
    else
      @orders = Order.page(params[:page]).per(10)
      @orders_all = Order.all.order('created_at ASC')
      order_date_sum = @orders_all.group("date(created_at)").sum(:total_price)
      @prices = order_date_sum.values
      @dates = order_date_sum.keys
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
