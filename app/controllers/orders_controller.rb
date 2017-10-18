class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
  end

  def update
    @order = Order.find(params[:id])

    @order.status = params[:status]
    @order.customer_name = params[:customer_name]
    @order.customer_email = params[:customer_email]
    @order.customer_address = params[:customer_address]
    @order.cc_number = params[:cc_number]
    @order.cc_expiration = params[:cc_expiration]
    @order.cc_ccv = params[:cc_ccv]
    @order.zip_code = params[:zip_code]

    result = @order.save

    if result
      flash[:notification] = 'Order was successfully updated'
    end
  end

  def show
    @order = Order.find(params[:id])
  end

end
