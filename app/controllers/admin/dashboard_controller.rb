class Admin::DashboardController < Admin::BaseController
  def index
  orders = Order.all
  @sorted_orders = orders.sort_by {|order| ["packaged", "pending", "shipped", "cancelled"].index(order.status)}
  end
end