class ReviewsController < ApplicationController

  skip_before_action :require_login

  def new
    @review = Review.new(product_id: params[:id])
    if restrict_merchants(@review)
      flash[:status] = :failure
      flash[:message] = "Failure: Merchants can not review their own products"
      redirect_to product_path(@review.product)
    end
  end

  def create
    @review = Review.new(review_params)
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

  private

  def restrict_merchants(review)
    return review.product.merchant.id == session[:merchant_id]
  end

  def review_params
    params.require(:review).permit(:rating, :text, :product_id)
  end
end
