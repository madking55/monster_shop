class User::OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to profile_orders_path
    flash[:notice] = "Order #{order.id} has just been cancelled"
  end
end