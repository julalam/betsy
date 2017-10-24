require "test_helper"

describe OrderItem do

  describe "relations" do
    it "belongs to an order and creates an error message if no order is given" do
      o = OrderItem.new(quantity: 2, product: products(:one))
      o.must_respond_to :order
      o.wont_be :valid?
      o.errors.messages.must_include :order
    end

    it "belongs to a product and creates an error message if no product is given" do
      o = OrderItem.new(quantity: 2, order: orders(:one))
      o.must_respond_to :product
      o.wont_be :valid?
      o.errors.messages.must_include :product
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

  describe "validations" do

    it "can be created with all required fields (including a positive integer for quantity)" do
      o = OrderItem.new(quantity: 3, order: orders(:one), product: products(:one))
      o.must_be :valid?
    end

    it "cannot be created without a quantity" do
      o = OrderItem.new( order: orders(:one), product: products(:one))
      o.wont_be :valid?
      o.errors.messages.must_include :quantity
      o.errors.messages.values.first.must_include "can't be blank"
    end

    it "cannot be created with a float" do
      o = OrderItem.new(quantity: 3.3, order: orders(:one), product: products(:one))
      o.wont_be :valid?
      o.errors.messages.must_include :quantity
      o.errors.messages.values.first.must_include "must be an integer"
    end


    it "cannot be created with a quantity of 0" do
      o = OrderItem.new(quantity: 0, order: orders(:one), product: products(:one))
      o.wont_be :valid?
      o.errors.messages.must_include :quantity
      o.errors.messages.values.first.must_include "must be greater than 0"
    end

    it "cannot be created with a negative quantity" do
      o = OrderItem.new(quantity: -1, order: orders(:one), product: products(:one))
      o.wont_be :valid?
      o.errors.messages.must_include :quantity
      o.errors.messages.values.first.must_include "must be greater than 0"
    end

  end

  describe "custom methods" do
    describe "total method" do
      # quantity for oi1 is 2 and price for product one is 2
      it "returns the subtotal (i.e., price * quantity)" do
        order_items(:oi1).total.must_equal 4
      end
    end
  end

end
