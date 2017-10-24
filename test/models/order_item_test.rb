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
