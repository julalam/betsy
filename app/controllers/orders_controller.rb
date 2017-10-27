class OrdersController < ApplicationController

  skip_before_action :require_login, except: [:index]

  def index
    if params[:merchant_id]
      unless allowed_user(params[:merchant_id])
        return
      end
      @merchant = Merchant.find_by(id: params[:merchant_id])
      if params[:status_id] == "paid"
        @order_items = @merchant.order_items_by_status("paid")
      elsif params[:status_id] == "pending"
        @order_items = @merchant.order_items_by_status("pending")
      else
        params[:status_id] == "all"
        @order_items = @merchant.order_items
      end
      render :merchant_orders
    end
  end

  def create
    @order = Order.new(status: "pending")
    @order.save
    redirect_to orders_path
  end

  def update
    #binding.pry
    @order = Order.find(params[:id])

    @order.customer_name = params[:order][:customer_name]
    @order.customer_email = params[:order][:customer_email]
    @order.customer_address = params[:order][:customer_address]
    @order.cc_number = params[:order][:cc_number]
    @order.cc_expiration = params[:order][:cc_expiration]
    @order.cc_ccv = params[:order][:cc_ccv]
    @order.zip_code = params[:order][:zip_code]

    params[:order].each do |key, value|
      if value == ""
        flash[:status] = :failure
        flash[:message] = "Any of required fields can't be empty"
        redirect_to edit_order_path(@order)
        return
      end
    end

    if @order.save!
      flash[:status] = :success
      flash[:message] = "Your order has been placed"
      @order.status = "paid"
      @order.save

      @order_items = OrderItem.where(order_id: "#{session[:order_id]}")

      @order.order_items.each do |item|
        @product = Product.find(item.product_id)
        @product.stock -= item.quantity
        @product.save
      end

      session[:order_id] = nil
    else
      flash[:status] = :failure
      flash[:message] = "Something went wrong. Please place your order again"
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def show
    @order = Order.find(params[:id])
    if params[:merchant_id]
      @order_items = @order.order_items.find_all{ |order_item| order_item.merchant == Merchant.find_by(id: params[:merchant_id]) }
      if @order_items.empty?
        redirect_to merchant_path(params[:merchant_id]), status: :bad_request
      else
        render :merchant_order, status: :ok
      end
      #looks like we do not need this
    # else
    #   @order_items = OrderItem.where(order_id: params[:id])
    end
  end
end
