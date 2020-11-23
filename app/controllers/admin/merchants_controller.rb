class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end
  
  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.status == 'enabled' ? disable_merchant(merchant) : enable_merchant(merchant)
    redirect_to admin_merchants_path
  end

  private

  def enable_merchant(merchant)
    merchant.update(status: 'enabled')
    merchant.items.update_all(active?: true)
    flash[:notice] = "#{merchant.name} has been enabled"
  end

  def disable_merchant(merchant)
    merchant.update(status: 'disabled')
    merchant.items.update_all(active?: false)
    flash[:notice] = "#{merchant.name} has been disabled"
  end
end