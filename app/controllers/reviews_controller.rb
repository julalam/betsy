class ReviewsController < ApplicationController
  def index
    @reviews = Review.all()
  end

  def show
    @review = Review.find(params[:id])
  end

  def edit
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new()
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@review.id}"
      redirect_to review_path(@review)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create review ID number #{@review.id}"
      flash[:messages] = @review.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def review_params
    params.require(:product_id).permit(:text)
  end
end
