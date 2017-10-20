require "test_helper"

describe ReviewsController do
  describe "new" do
    it "works" do
      get new_review_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "succeeds for an valid review ID" do
      #when we get seed data we can clean this up
      get review_path(reviews(:one).product_id)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus review ID" do
      get review_path(9999)
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "succeeds for an extant review ID" do
      #when we get seed data we can clean this up
      review = Product.new(product_id: reviews(:one).id, text: 'new review text')

      get edit_review_path(review.id)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus review ID" do
      #when we get seed data we can clean this up

      get edit_review_path(99999999)
      must_respond_with :not_found
    end
  end

  describe "index" do
    it "succeeds when there are reviews" do
      #when we get seed data we can clean this up
      get reviews_path
      must_respond_with :success
    end

    it "succeeds when there are no reviews" do
      Review.destroy_all
      get reviews_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a review with valid data" do
      review = Review.create
      review_data = {
        review: {
          product_id: 93892,
          text: 'review text'
        }
      }
      start_count = Review.count

      post reviews_path, params: review_data

      must_redirect_to review_path(Review.last)
      Review.count.must_equal start_count + 1
    end

    it "renders bad_request and does not update the DB for bogus data" do
      review_data = {
        review: {
          product_id: nil
        }
      }
      start_count = Review.count

      post reviews_path, params: review_data

      must_redirect_to review_path(Review.last)
      Review.count.must_equal start_count
    end
  end


  describe "update" do
    it "succeeds for valid data and an valid review ID" do
      review = Review.create


      review = Review.first
      review_data = {
        review: {
          product_id: 1,
          text: 'new review text'
        }
      }
      start_count = Review.count

      patch review_path(review), params: review_data

      must_redirect_to product_path(Review.last)
      Review.count.must_equal start_count
    end

    it "renders bad_request for bogus data" do
      review = Review.first
      review_data = {
        review: {
          product_id: nil
        }
      }
      start_count = Review.count

      patch review_path(review), params: review_data

      must_redirect_to product_path(Review.last)
      Review.count.must_equal start_count
    end

    it "renders 404 not_found for a bogus review ID" do



      get review_path(999902309123)
      must_respond_with :not_found
    end
  end
end
