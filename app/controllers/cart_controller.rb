class CartController < ApplicationController
  before_action :exclude_admin
  
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def update_quantity
    item = Item.find(params[:item_id])
    if params[:change] == 'more'
      cart.add_item(params[:item_id]) unless item.inventory <= cart.contents[item.id.to_s]
    elsif params[:change] == 'less'
      cart.contents[item.id.to_s] -= 1
      return remove_item if cart.contents[item.id.to_s] == 0
    end
    session[:cart] = cart.contents
    redirect_to '/cart'
  end
end
