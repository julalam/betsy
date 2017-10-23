class OrderItemsController < ApplicationController
  skip_before_action :require_login


  def index
    #maybe just for that merchant
    @order_items = OrderItem.where(order_id: session[:order_id])
  end

  def new
    @order_item = OrderItem.new
  end

  def create
    #if there is already an open order, set the order_item order_id to that order.
    #otherwise make a new order
    puts "before"
    puts session[:order_id]
    if session[:order_id] == nil
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end
    puts "after:"
    puts session[:order_id]
    @order_item = OrderItem.new(product_id: params[:order_item][:product_id], quantity: params[:order_item][:quantity], order_id: session[:order_id])
    @order_item.save!
    redirect_to order_items_path
    # else
    #   #
    #   # render :new
    #   flash[:status] = :failure
    #   flash[:result_text] = "Could not create order item"
    #   flash[:details] = @order_item.errors.messages
    # end
  end

  def update
    @order_item = OrderItem.find(params[:id])
    # @order_item.update_attributes(order_item_params)
    # if @order_item.save
    #   redirect_to root_path
    # else
    #   # render :edit
    # end

    @order_item.update_attributes(order_item_params)

    # if save_and_flash(@order_item, "update")
    if @order_item.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order item."
      redirect_back fallback_location: { action: "index"}
      # redirect_to order_item_path(@order_item.id)
    else
      render :edit, status: :bad_request
    end
  end


  def destroy
    @order_item = OrderItem.find(params[:id])
    if @order_item.destroy
      flash.now[:status] = :success
      flash.now[:message] = "Successfully removed #{@order_item.product.name} from your cart"
      render :index
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Problem encountered when attempting to remove #{@order_item.product.name} from your cart"
    end
  end

  private

  def order_item_params
    return params.require(:order_item).permit(:product_id, :quantity, :order_id, :status)
  end
end
