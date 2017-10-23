class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if params[:order][:status] == " "
      flash[:failure] = 'Please enter the required fields.'
      redirect_to new_order_path
    else
      @order = Order.new(order_params)
      if @order.save
        flash[:success] = 'Your order has been placed'
        redirect_to orders_path
      else
        flash[:failure] = 'Something went wrong. Please place your order again'
        redirect_to orders_path
      end
    end
  end

  def update
    @order = Order.find(params[:id])

    @order.customer_name = params[:order][:customer_name]
    @order.customer_email = params[:order][:customer_email]
    @order.customer_address = params[:order][:customer_address]
    @order.cc_number = params[:order][:cc_number]
    @order.cc_expiration = params[:order][:cc_expiration]
    @order.cc_ccv = params[:order][:cc_ccv]
    @order.zip_code = params[:order][:zip_code]

    # result = @order.save
    puts "session before #{session[:order_id]}"

    if @order.save!
      flash[:notification] = 'Order was successfully updated'
      @order.status = "paid"
      @order.save
      session[:order_id] = nil
    else
      flash[:failure] = 'Order was not updated'
    end
    puts "session after #{session[:order_id]}"
    redirect_to order_path(@order.id)
  end

  def edit
    @order = Order.find(params[:id])
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:customer_email, :customer_name,
      :zip_code, :cc_expiration, :status, :cc_ccv, :cc_number, :customer_address)
  end

end
