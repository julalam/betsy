require "test_helper"

describe OrderItem do
  let(:order_item_1){ OrderItem.create!(product_id: products(:one).id, order_id: orders(:one).id, quantity: 3)}
  describe "relations" do
    it "has an order" do
      order_item_1.must_respond_to :order
      order_item_1.order.must_be_kind_of Order
    end

    it "has a product" do
      order_item_1.must_respond_to :product
      order_item_1.product.must_be_kind_of Product
    end
  end

  describe "total cost" do
    let(:order_item_2){ OrderItem.create!(product_id: products(:two).id, order_id: orders(:one).id, quantity: 3)}

    it "given one order_item, returns the cost of that order_item" do
      OrderItem.total_cost(order_item_1).must_equal 6
    end

    it "given a collection of order_items, returns the cost of those items" do
      OrderItem.destroy_all
      order_item_1
      order_item_2
      order_items = OrderItem.all
      OrderItem.total_cost(order_items).must_equal 15
    end
  end
end
