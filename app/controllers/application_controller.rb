class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_product_names

  def after_sign_up_path_for(resource)
    customers_path
  end

  def after_sign_in_path_for(resource)
      case resource
      when Admin
        admin_orders_path
      when Customer
        root_url
      end
  end

  def after_sign_out_path_for(resource)
    if resource == :admin
      new_admin_session_path
    else
      root_url
    end
  end
  
  # 検索のサジェストで表示する商品名の設定
  def set_product_names
    product_names = Product.where(is_active: true).pluck(:name).push(",")
    product_names_hira = product_names.map do |name|
      if name.is_kana?
        name.to_hira
      else
        name
      end
    end
    @product_names_all = product_names.push(product_names_hira).flatten!.uniq.join(",")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :last_name_kana, :first_name_kana, :phone_number, :postcode, :address])
  end
end
