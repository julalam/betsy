class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.where(order_id: session[:order_id])
  end

  def new
    @order_item = OrderItem.new
  end

  def create
    if session[:order_id] == nil
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end
    @order_item = OrderItem.new(product_id: params[:order_item][:product_id], quantity: params[:order_item][:quantity], order_id: session[:order_id])

    @order_item.save!
    redirect_to order_items_path
  end

  def update
    @order_item = OrderItem.find(params[:id])
    @order_item.update_attributes(order_item_params)
    if @order_item.save
      redirect_to root_path
    else

    end

    @order_item.update_attributes(order_item_params)

    if save_and_flash(@order_item, "update")
      redirect_to order_item_path(@order_item.id)
    else
      render :edit, status: :bad_request
    end
  end


  def destroy
    current_merchant = Merchant.find_by(id: session[:logged_in_merchant])
    @order = OrderItem.find_by(id: params[:id])
    if current_merchant == order.product.merchant
      @order.destroy
      flash[:status] = :success
      flash[:result_text] = "Successfully destroyed order item."
      redirect_to root_path
    else
      flash[:status] = :failure
      flash[:message] = "You must be the merchant for that item to do that!"
      redirect_to root_path
      return
    end
  end

  private

  # def order_item_params
  #   return params.require(:orderitem).permit(:product_id, :quantity, :order_id)
  # end
end
