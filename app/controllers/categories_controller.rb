class CategoriesController < ApplicationController

  def new
    @category = Category.new
    unless allowed_user(params[:merchant_id])
      return
    end
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def index
    if params[:merchant_id]
      unless allowed_user(params[:merchant_id])
        return
      end
    end
    @categories = Category.all
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def create
    @category = Category.new(category_params)
    @merchant = Merchant.find_by(id: session[:merchant_id])

    if Category.all.find_by(name: @category.name)
      flash[:status] = :failure
      flash[:message] = "Category already exist"
      redirect_to new_merchant_category_path(@merchant.id)
    elsif @category.save
      flash[:status] = :success
      flash[:message] = "Successfully created category: #{@category.name}"
      redirect_to merchant_categories_path(@merchant.id)
    else
      flash[:status] = :failure
      flash[:message] = "Could not create category"
      flash[:messages] = @category.errors.messages
      redirect_to new_merchant_category_path(@merchant.id)
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end
end
