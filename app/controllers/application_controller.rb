class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :last_name_kana, :first_name_kana, :phone_number, :postcode, :address])
  end
  before_action :configure_permitted_parameters, if: :devise_controller?
  
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
    root_url
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :last_name_kana, :first_name_kana, :phone_number, :postcode, :address])
  end
end
