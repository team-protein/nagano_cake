class AddressesController < ApplicationController
  before_action :authenticate_customer!
  def index
    @address = Address.new
    @addresses = current_customer.addresses
  end

  def show
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      @address_new = Address.new
      @addresses = current_customer.addresses
      respond_to do |format|
        format.html {redirect_to addresses_path}
        format.js
      end
    else
      @addresses = current_customer.addresses
      render 'error'
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path
    else
      render 'addresses/edit'
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    @addresses = current_customer.addresses
    respond_to do |format|
      format.html {redirect_to addresses_path}
      format.js
    end
  end

  private

  def address_params
    params.require(:address).permit(:postcode, :address, :dear)
  end
end
