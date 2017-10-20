class ProductsController < ApplicationController

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product[:merchant_id] = session[:merchant_id]
    @product[:retired] = false
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@product.name}, ID number #{@product.id}"
      redirect_to merchant_products_path(session[:merchant_id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product.name}, ID number #{@product.id}"
      flash[:messages] = @product.errors.messages
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
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}, ID number #{@product.id}"
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not updated #{@product.name}, ID number #{@product.id}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end


  def index
    if params[:category_id]
      category = Category.find_by(id: params[:category_id])
      @products = category.products
    elsif params[:merchant_id]
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @products = @merchant.products
      render :merchant_products
    else
      @products = Product.all
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :stock, :description, :image_url)
  end
end

# name: params[:product][:name],price: params[:product][:price], stock: params[:product][:stock], retired: params[:product][:retired], description: params[:product][:description], image_url: params[:product][:image_url], merchant: params[:product][:merchant]
