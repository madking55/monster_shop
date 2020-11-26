class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items_quantity
    item_orders.sum(:quantity)
  end

  def cancel
    update(status: 'cancelled')
    item_orders.each do |item_order|
      item_order.update(fulfilled: false)
      item_order.item.update(inventory: item_order.item.inventory + item_order.quantity)
    end
  end

  def is_packaged?
    update(status: 'packaged') if item_orders.distinct.pluck(:fulfilled) == [true]
  end

  def merchant_quantity(merchant_id)
    item_orders
      .joins("JOIN items ON item_orders.item_id = items.id")
      .where("items.merchant_id = #{merchant_id}")
      .sum("item_orders.quantity")
  end

  def merchant_subtotal(merchant_id)
    item_orders
    .joins("JOIN items ON item_orders.item_id = items.id")
    .where("items.merchant_id = #{merchant_id}")
    .sum('item_orders.price * item_orders.quantity')
  end
end
