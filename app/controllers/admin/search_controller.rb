class Admin::SearchController < ApplicationController
  def search
    @model = params[:model]
    @method = params[:method]
    @content = params[:content]
    if @model == 'customer'
      @title = '会員'
      @records = Customer.search_for(@content, @method).page(params[:page])
    else
      @title = '商品'
      @records = Product.search_for(@content, @mehtod).page(params[:page])
    end
  end
end
