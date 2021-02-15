class CustomersController < ApplicationController
    def show
    end
    
    def delete_confirm
        
    end
    
    def withdraw
        current_customer.is_deleted = true
        current_customer.save
        reset_session
        redirect_to root_url
    end
end
