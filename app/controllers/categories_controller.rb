class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  # def index
  #   @categoty = Category.all
  # end
  #
  # def show
  #   @categories = Category.find(params[:id])
  #   @category = @category.product
  # end


  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:status] = :success
      flash[:message] = "Successfully created category: #{@category.name}"
      redirect_to root_path
    else
      flash[:status] = :failure
      flash[:message] = "Could not create category"
      flash[:details] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end
end
