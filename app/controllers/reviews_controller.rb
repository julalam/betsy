class ReviewsController < ApplicationController

  skip_before_action :require_login

  def new
    @review = Review.new(product_id: params[:id])
    restrict_merchants(@review)
  end

  def create
    @review = Review.new(review_params)
    if restrict_merchants(@review)
      if @review.save
        flash[:status] = :success
        flash[:message] = "Successfully created new review"
        redirect_to product_path(@review.product)
      else
        flash[:status] = :failure
        flash[:message] = "Failure: Could not create new review"
        flash[:messages] = @review.errors.messages
        render :new, status: :bad_request
      end
    end
  end

  private

  def restrict_merchants(review)
    if  session[:merchant_id] == review.product.merchant_id
      flash[:status] = :failure
      flash[:message] = "Failure: Merchants can not review your own products"
      redirect_to product_path(review.product)
      return false
    else
      return true
    end
  end

  def review_params
    params.require(:review).permit(:rating, :text, :product_id)
  end
end
