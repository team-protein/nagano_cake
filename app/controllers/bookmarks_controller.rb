class BookmarksController < ApplicationController
  before_action :authenticate_customer!
  def create
    @product = Product.find(params[:product_id])
    @bookmark = current_customer.bookmarks.new(product_id: @product.id)
    @bookmark.save
  end

  def destroy
    @product = Product.find(params[:product_id])
    @bookmark = current_customer.bookmarks.find_by(product_id: @product.id)
    @bookmark.destroy
  end
end
