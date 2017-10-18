class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    if params[:work][:status] == " "
      flash[:failed] = 'Enter a status'
    else
      @order = Order.new(
        status: 'pending',
        customer_name: params[:order][:customer_name],
        customer_email: params[:order][:customer_email],
        customer_address: params[:order][:customer_address],
        cc_number: params[:order][:cc_number],
        cc_expiration: params[:order][:cc_expiration],
        cc_ccv: params[:order][:cc_ccv],
        zip_code: params[:order][:zip_code],
      )
      result = @order.save

      if result
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
    else
      flash[:failure] = 'Order was not updated'
    end
  end

  def show
    @order = Order.find(params[:id])
  end

end
