class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end
  
  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(status: 'disabled')
    flash[:notice] = "#{merchant.name} has been disabled"
    redirect_to admin_merchants_path
  end
end