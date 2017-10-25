class OrderItemsController < ApplicationController
  skip_before_action :require_login


  def index
    @order_items = OrderItem.where(order_id: session[:order_id])
  end

  def create
    #if there is already an open order, set the order_item order_id to that order.
    #otherwise make a new order
    if session[:order_id] == nil
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end

    @product = Product.find(params[:order_item][:product_id])
    if retired?
      return
    end
    #stock logic
    if params[:order_item][:quantity].to_i > @product.stock.to_i
      flash.now[:status] = :failure
      flash.now[:message] = "There is not enough stock. Order a smaller amount"
      #redirect_to order_items_path
    else

      if consoldate_order_items(session[:order_id],params[:order_item][:product_id], params[:order_item][:quantity])
        redirect_to order_items_path
        return
      end

      @order_item = OrderItem.new(order_item_params)
      @order_item.order_id = session[:order_id]
      if @order_item.save
        flash[:status] = :success
        flash.now[:message] = "Successfully added #{@order_item.product.name} to your cart"
        redirect_to order_items_path
      else
        flash.now[:status] = :failure
        flash.now[:message] = "Could not add #{@order_item.product.name} to your cart"
        redirect_to root_path
      end
    end
  end

  def update
    @order_item = OrderItem.find(params[:id])

    @product = Product.find(@order_item.product_id)

    if params[:order_item][:quantity].to_i > @product.stock.to_i
      flash.now[:status] = :failure
      flash.now[:message] = "There is not enough stock. Order a smaller amount"
      redirect_to order_items_path
    end

    @order_item.update_attributes(order_item_params)
    if @order_item.save
      flash[:status] = :success
      flash[:message] = "Successfully updated order item."
      redirect_to order_items_path
    else
      render :edit, status: :bad_request
    end
  end


  def destroy
    @order_item = OrderItem.find(params[:id])
    @product = Product.find(@order_item.product_id)
    @product.stock += @order_item.quantity
    @product.save
    # result = @order_item.destroy
    if @order_item.destroy
      flash.now[:status] = :success
      flash.now[:message] = "Successfully removed #{@order_item.product.name} from your cart"
      redirect_to order_items_path
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Problem encountered when attempting to remove #{@order_item.product.name} from your cart"
      redirect_to order_items_path
    end
  end

  private

  def consoldate_order_items(order_id, product_id, quantity)
    @order_items = OrderItem.where(order_id: order_id)
    product_id = product_id.to_i
    quantity = quantity.to_i
    @order_items.each do |order_item|
      if order_item.product_id == product_id
        order_item.quantity += quantity
        order_item.save
        flash[:status] = :success
        flash[:message] = "Successfully added products to your cart"
        #if the user requests more items than we have in stock
        if order_item.quantity > order_item.product.stock
          flash.now[:status] = :failure
          flash.now[:message] = "There are only #{order_item.product.stock} of that items in stock.  The quanitity of #{order_item.product.name}s has been set to the max value."
          order_item.quantity = order_item.product.stock
          order_item.save
          puts order_item.quantity
        end
        return true #if there was a repeat order
      end
    end
    return false # there was not repeat order
  end

  def retired?
    if @product.retired == true
      flash.now[:status] = :failure
      flash.now[:message] = "You can not order a retired item"
      redirect_to product_path(@product)
    end
  end

  def order_item_params
    return params.require(:order_item).permit(:product_id, :quantity, :order_id, :status)
  end
end
