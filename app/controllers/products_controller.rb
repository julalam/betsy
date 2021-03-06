class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:show, :index, :index_by_merchant, :index_by_category]

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
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
      render :new
    end
  end

  def edit
    product = Product.find(params[:id])
    unless allowed_user(product.merchant.id)
      return
    end
    @product = product

  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product == nil
      render_404
    else
      @order_item = OrderItem.new(product_id: params[:id])
    end
  end

  def update
    product = Product.find(params[:id])
    puts product.merchant.id
    puts session[:merchant_id]
    unless allowed_user(product.merchant.id)
      return
    end
    @product = product
    @product.update_attributes(product_params)
    puts @product.inspect
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
    #puts "I am in regular index"
    if params[:merchant_id]
      unless allowed_user(params[:merchant_id])
        return
      end
    end
    #puts "I made it past the allowed_user check"
    #puts "these are my params: #{params}"

    #The below is nessesary for the merchant user stories.
    if params[:merchant_id] && params[:category_id]
      #puts "I have a merchant id and a category id"
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @category = Category.find_by(id: params[:category_id])
      @products = @category.products.where(merchant: @merchant)
    elsif params[:category_id]
      #puts "I only have a category id"
      category = Category.find_by(id: params[:category_id])
      @products = category.products
    elsif params[:merchant_id]
      puts "I only have a merchant id"
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @products = @merchant.products

      render :merchant_products, status: :ok
      # @merchant_id = params[:merchant_id]
      #merchant_id: @merchant.id
    else
      #puts "I got nothing"
      @products = Product.all
    end
  end

  #if we have time, add a render 404 for bogus merchants
  def index_by_merchant
    @merchant = Merchant.find_by(id: params[:id])
    @products = @merchant.products
    render :index
  end

  #if we have time, add a render 404 for bogus categories
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
