class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.merchant.items
  end

  def new
    @merchant = current_user.merchant
  end

  def create
    @merchant = current_user.merchant
    @item = @merchant.items.new(item_params)
    if @item.save
      flash[:notice] = "#{@item.name} has been added"
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
   @item = Item.find(params[:id])
  end

  def change_status
    item = Item.find(params[:id])
    item.update(active?: !item.active?)
    if item.active? 
      flash[:notice] = "#{item.name} is available for sale"
    else
      flash[:notice] = "#{item.name} is no longer for sale"
    end
    redirect_to '/merchant/items'
  end

  def destroy
    item = Item.find(params[:id])
    if item.orders.empty?
      item.destroy
      flash[:notice] = "#{item.name} has been deleted"
    else 
      flash[:notice] = "#{item.name} cannot be deleted - it has been ordered!"
    end
    redirect_to '/merchant/items'
  end
end

private

def item_params
  params.permit(:name, :description, :price, :image, :inventory)
end
