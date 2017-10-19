class ProductsController < ApplicationController

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@product.name}, ID number #{@product.id}"
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product.name}, ID number #{@product.id}"
      flash[:messages] = @work.errors.messages
      render :new, status: :bad_request
    end
  end

  def edit
      @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
  end

  def update
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
    @products = Product.all
  end

  private

  def product_params
    params.require(:name).permit(:price, :stock, :retired, :description, :image_url, :merchant_i)
  end
end
