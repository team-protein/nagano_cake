class HomesController < ApplicationController

  def top
    @products = Product.where(is_active: true).order("created_at DESC").limit(4)
  end

  def about
  end

end
