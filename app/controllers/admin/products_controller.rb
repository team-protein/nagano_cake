class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.name.match(/[一-龠々]/) #漢字が含まれているとき
      word = @product.name
      word = word.gsub(/[0-9]/, "") #数字を削除する
      word = word.gsub(/[０-９]/, "")
      @product.conversion_name = word.to_kanhira
    elsif @product.name.is_kana? #カタカナのとき
      @product.conversion_name = @product.name.to_hira
    else
      @product.conversion_name = @product.name
    end
    if @product.save
      redirect_to admin_product_path(@product)
    else
      render :new
    end
  end

  def index
    @products = Product.page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_product_path(@product)
    else
      render :edit
    end
  end

  private
    def product_params
      params.require(:product).permit(:genre_id, :name, :description, :price, :is_active, :image)
    end

end
