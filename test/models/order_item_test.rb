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



    # it "has an order" do
    #   order_item_1.must_respond_to :order
    #   order_item_1.order.must_be_kind_of Order
    # end
    #
    # it "has a product" do
    #   order_item_1.must_respond_to :product
    #   order_item_1.product.must_be_kind_of Product
    # end
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
    describe "subtotal and total_cost" do
      before do
        @order_item = OrderItem.new(quantity: 3, order: orders(:one), product: products(:one))
        @other_order_item = OrderItem.new(quantity: 2, order: orders(:one), product: products(:two))
      end

      it "returns the right subtotal" do
        OrderItem.subtotal(@order_item).must_equal @order_item.quantity * @order_item.product.price
      end

      it "returns the right total cost" do
        OrderItem.total_cost([@order_item, @other_order_item]).must_equal @order_item.quantity * @order_item.product.price + @other_order_item.quantity * @other_order_item.product.price
      end
    end
  end

end
