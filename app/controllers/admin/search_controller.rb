class Admin::SearchController < ApplicationController
  before_action :authenticate_admin!

  def search
    @model = params[:model]
    @content = params[:content]
    if @model == 'customer'
      @records = Customer.search_for(@content).page(params[:page])
    else
      @records = Product.search_for(@content).page(params[:page])
    end
  end
end
