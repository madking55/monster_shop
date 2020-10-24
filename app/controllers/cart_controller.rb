class CartController < ApplicationController
  before_action :exclude_admin
  
  def add_item
    item = Item.find(params[:item_id])
    if cart.limit_reached?(item.id)
      flash[:notice] = "You have all the item's inventory in your cart already!"
    else
      cart.add_item(item.id.to_s) 
      flash[:success] = "#{item.name} was successfully added to your cart"
    end
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
      cart.add_item(params[:item_id])
    elsif params[:change] == 'less'
      cart.less_item(params[:item_id])
      return remove_item if cart.contents[item.id.to_s] == 0
    end
    session[:cart] = cart.contents
    redirect_to '/cart'
  end
end
