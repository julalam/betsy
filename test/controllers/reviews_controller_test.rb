require "test_helper"

describe ReviewsController do
  describe "new" do
    before do
      @owner = merchants(:eva)
      @user = merchants(:emma)
      @product = @owner.products.first
      @right_review = Review.new(product_id: @product.id, rating: 5)
      @wrong_review = Review.new(product_id: @product.id, rating: 3)
    end

    it "works for not owners of the product" do
      get new_product_review_path(@product.id)
      must_respond_with :success
    end

    it "not works for the owner of the product" do
      login(@owner)
      get new_product_review_path(@product.id)
      must_respond_with :redirect
      must_redirect_to product_path(@product)
    end
  end

  describe "create" do
    it "creates a review with valid data" do
      review_data = {
        review: {
          product_id: products(:one).id,
          rating: 2,
          text: "review text"
        }
      }
      Review.new(review_data[:review]).must_be :valid?
      start_count = Review.count

      post reviews_path, params: review_data

      must_respond_with :redirect
      must_redirect_to product_path(products(:one))
      Review.count.must_equal start_count + 1
    end

    it "renders bad_request and does not update the DB for bogus data" do
      review_data = {
        review: {
          product_id: products(:one).id,
          rating: nil
        }
      }
      start_count = Review.count

      post reviews_path, params: review_data

      must_respond_with :bad_request
      Review.count.must_equal start_count
    end
  end
end
