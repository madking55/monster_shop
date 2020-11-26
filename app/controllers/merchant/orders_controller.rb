class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:id])
    @merchant = current_user.merchant
  end

  def fulfill
    order = Order.find(params[:order_id])
    item_order = order.item_orders.find(params[:item_order_id])
    item_order.fulfill if item_order.fulfillable?
    order.is_packaged?
    flash[:notice] = 'Item fulfilled!'
    redirect_to "/merchant/orders/#{params[:order_id]}"
  end
end
