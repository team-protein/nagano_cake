class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
  end
  
  def show
    @order = Order.find(params[:id])
  end
  
end
