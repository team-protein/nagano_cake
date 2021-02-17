class SearchController < ApplicationController
  def search
    @content = params[:content]
    @genre = params[:genre]
    if @content != "" &&  @genre == ""
      @records = Product.name_search_for(@content).order("created_at DESC").page(params[:page]).per(8)
    elsif @content == "" && @genre != ""
      @records = Product.genre_search_for(@genre).order("created_at DESC").page(params[:page]).per(8)
    else
      @records = Product.name_and_genre_search_for(@content, @genre).order("created_at DESC").page(params[:page]).per(8)
    end
  end
end
