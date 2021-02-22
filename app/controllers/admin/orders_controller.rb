class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:user_id].present?
      customer = Customer.find(params[:user_id])
      @orders = customer.orders.page(params[:page]).per(10)
      @orders_month_sum = customer.orders.group(:created_month).sum(:total_price).to_a
    else
      @orders = Order.page(params[:page]).per(10)
      @orders_month_sum = Order.group(:created_month).sum(:total_price).to_a
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
