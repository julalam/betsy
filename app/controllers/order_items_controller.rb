class OrderItemsController < ApplicationController

  def index
    #maybe just for that merchant
    @order_items = OrderItem.all
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    if @order_item.save
      # probably only need flash messages for the order?
      # flash[:status] = :success
      # flash[:result_text] = "Successfully created order item"
      redirect_to root_path
    else
      #
      # render :new
      flash[:status] = :failure
      flash[:result_text] = "Could not create order item"
      flash[:details] = @order_item.errors.messages
    end
  end

  def update
    @order_item = OrderItem.find(params[:id])
    @order_item.update_attributes(order_item_params)
    if @order_item.save
      redirect_to root_path
    else
      # render :edit
    end
  end

  @work.update_attributes(work_params)
  if save_and_flash(@work, "update")
    redirect_to work_path(@work.id)
  else
    render :edit, status: :bad_request
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

  def order_item_params
    return params.require(:orderitem).permit(:product_id, :quantity, :order_id)
  end
end
