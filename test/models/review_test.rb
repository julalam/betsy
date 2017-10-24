require "test_helper"

describe Review do
  describe "relations" do
    before do
      @review = reviews(:one)
    end

    it "belongs to product" do
      @review.must_respond_to :product
      @review.product.must_be_kind_of Product
    end
  end

  describe "validations" do
    it "requires rating to be created" do
      review = Review.new
      review.wont_be :valid?
    end

    it "can be created with valid rating" do
      review = Review.new(rating: 4, product: products(:one))
      review.must_be :valid?
    end

    it "requires rating to be 1-5" do
      review = Review.new(rating: 10, product: products(:one))
      review.wont_be :valid?
    end

    it "rating has to be an integer" do
      review = Review.new(rating: 4.5, product: products(:one))
      review.wont_be :valid?
    end
  end

end
