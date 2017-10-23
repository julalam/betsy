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

end
