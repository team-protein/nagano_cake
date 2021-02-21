class CustomersController < ApplicationController
    before_action :authenticate_customer!

    def show
    end

    def delete_confirm
    end

    def withdraw
        current_customer.is_deleted = true
        current_customer.save
        reset_session
        flash[:notice] = "ありがとうございました。またのご利用を心よりお待ちしております。"
        redirect_to root_url
    end

    def bookmarks
      @products = Kaminari.paginate_array(
                  Bookmark.where(customer_id: current_customer.id).order("created_at DESC").map{|bookmark| bookmark.product}
                  ).page(params[:page]).per(8)
    end
end
