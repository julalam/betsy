require "test_helper"

describe OrderItem do
  describe "relations" do
    it "has an order" do
      o = orderitems(:one)
      o.must_respond_to :order_id
      o.order.must_be_kind_of Integer
    end

    it "has a product" do
      o = orderitems(:one)
      o.must_respond_to :product_id
      o.order.must_be_kind_of Integer
    end
  end
end
