class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:id])
    @merchant = current_user.merchant
  end

  def fulfill
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.fulfill
    flash[:notice] = 'Item fulfilled!'
    redirect_to "/merchant/orders/#{params[:order_id]}"
  end
end
