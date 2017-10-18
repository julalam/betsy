require "test_helper"

describe OrderItem do
  # let(:order_item) { OrderItem.new }
  #
  # it "must be valid" do
  #   value(order_item).must_be :valid?
  # end

  describe "relations" do
    it "has an order" do
      o = orderitems(:one)
      o.must_respond_to :order
      o.order.must_be_kind_of Order
    end

    it "has a product" do
      o = orderitems(:one)
      o.must_respond_to :product
      o.order.must_be_kind_of Product
    end
  end
end
