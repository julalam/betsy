class OrdersController < ApplicationController

  skip_before_action :require_login

  def index
    if params[:merchant_id]
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @order_items = @merchant.order_items
      render :merchant_orders
    else
      @orders = Order.all
    end
  end

  def new
    @order = Order.new
  end

  def create
    if params[:order][:status] == " "
      flash[:failure] = 'Please enter the required fields.'
      redirect_to new_order_path
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

    @order.customer_name = params[:order][:customer_name]
    @order.customer_email = params[:order][:customer_email]
    @order.customer_address = params[:order][:customer_address]
    @order.cc_number = params[:order][:cc_number]
    @order.cc_expiration = params[:order][:cc_expiration]
    @order.cc_ccv = params[:order][:cc_ccv]
    @order.zip_code = params[:order][:zip_code]

    if @order.save!
      flash[:notification] = 'Order was successfully updated'
      @order.status = "paid"
      @order.save
      session[:order_id] = nil
    else
      flash[:failure] = 'Order was not updated'
    end
    redirect_to order_path(@order.id)
  end

  def edit
    @order = Order.find(params[:id])
  end

  def show
    if params[:merchant_id]
      @order = Order.find(params[:id])
      @order_items = []
      @order.order_items.each do |order_item|
        if order_item.merchant == Merchant.find_by(id: params[:merchant_id])
          @order_items << order_item
        end
      end
      puts "count #{@order_items.count}is empty? #{@order_items.empty?} "
      if @order_items.empty?
        puts "is empty true "
        redirect_to merchant_path(params[:merchant_id]), status: :bad_request
      else
        puts "is empty false"
        render :merchant_order, status: :ok
      end
    else
      @order = Order.find(params[:id])
      @order_items = OrderItem.where(order_id: params[:id])
    end
  end

  # def cancel
  #   @order = Order.find(params[:id])
  #    @order[:status] = "Canceled"
  #    redirect_to order_path(@order.id)
  # end

end
