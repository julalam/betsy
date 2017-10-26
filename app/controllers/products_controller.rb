class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:show, :index, :index_by_merchant, :index_by_category]

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    #if price is entered, change to cents
    # if params[:product][:price] != ""
    #   @product.price = (params[:product][:price].to_i * 100)
    # end

    @product[:merchant_id] = session[:merchant_id]
    @product[:retired] = false
    if @product.save
      flash[:status] = :success
      flash[:message] = "Successfully created new product #{@product.name}, ID number #{@product.id}"
      redirect_to merchant_products_path(session[:merchant_id])
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Could not create new product #{@product.name}"
      flash.now[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
    @order_item = OrderItem.new(product_id: params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.update_attributes(product_params)
    #if price is entered, change to cents
    # if params[:product][:price].to_i != @product.price
    #   @product.price = (params[:product][:price].to_i * 100)
    # end

    if @product.save
      flash[:status] = :success
      flash[:message] = "Successfully updated #{@product.name}, ID number #{@product.id}"
      redirect_to merchant_products_path(session[:merchant_id])
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Could not updated #{@product.name}, ID number #{@product.id}"
      flash.now[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end


  def index
    @products = Product.all.where("stock > 0")
  end
=begin
  None of these should ever be hit because the index
  page doesn't take parameters.
  Plus the logic of showing products of a specific
  category or merchant is handled elsewhere.
    if params[:merchant_id]
      unless allowed_user(params[:merchant_id])
        raise
        return
      end
    end

    if params[:merchant_id] && params[:category_id]
      raise
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @category = Category.find_by(id: params[:category_id])
      @products = @category.products.where(merchant: @merchant)
    elsif params[:category_id]
      raise
      category = Category.find_by(id: params[:category_id])
      @products = category.products
    elsif params[:merchant_id]
      raise
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @products = @merchant.products
      render :merchant_products
    else

    end

=end
  def index_by_merchant
    @merchant = Merchant.find_by(id: params[:id])
    @products = @merchant.products
    render :index
  end

  def index_by_category
    @category = Category.find_by(id: params[:id])
    @products = @category.products
    render :index
  end

  private

  def product_params
    params.require(:product).permit(:name, :stock, :price, :retired, :description, :image_url, category_ids: [])
  end
end
