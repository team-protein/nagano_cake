class SearchController < ApplicationController
  def search
    @content = params[:content]
    @genre = params[:genre]
    @records = Product.genre_search_for(@content, @genre).order("created_at DESC").page(params[:page]).per(8)
  end
end
