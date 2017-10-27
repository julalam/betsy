require "test_helper"

describe OrdersController do
  describe "login tests" do
    before do
      @merchant = merchants(:eva)
      @user = merchants(:emma)
      login(@merchant)
    end

    describe "index" do
      it "returns success for all orders" do
        get merchant_orders_path(@merchant.id, "all")
        must_respond_with :success
      end

      it "returns success for orders with status paid" do
        get merchant_orders_path(@merchant.id, "paid")
        must_respond_with :success
      end

      it "returns success for orders with status pending" do
        get merchant_orders_path(@merchant.id, "pending")
        must_respond_with :success
      end

      it "not allows other users to see orders page" do
        get merchant_orders_path(@user.id, "all")
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end

  describe "primary pages that not requires login" do
    before do
      @merchant = merchants(:eva)
      @order = orders(:one)
    end

    describe "index" do
      it "requires login in order to be able to see orders page" do
        get merchant_orders_path(@merchant.id, "all")
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "merchant show page" do
      it "gets show page for merchant order" do
        get merchant_order_path(@merchant.id, @order.id)
        must_respond_with :success
      end

      it "must not find invalid show page for merchant order" do
        get merchant_order_path(merchants(:no_orders).id, orders(:two).id)
        must_respond_with :bad_request
      end
    end

    it "must get edit page" do
      get edit_order_path(orders(:two).id)
      assert_response :success
    end

    it "must not find an invalid edit page" do
      get edit_order_path(Order.last.id + 1)
      must_respond_with :not_found
    end

  end

  describe "create" do
    it "creates a new order with no data" do
      order_data = {
        order: {
          status: "pending"
        }
      }
      start_count = Order.count
      post orders_path, params: order_data

      must_respond_with :redirect
      must_redirect_to orders_path
      Order.count.must_equal start_count + 1
    end
  end

  describe "update" do
    it "places order when all the information filled in" do
      order = Order.first
      order_data = {
        id: order.id,
        order: {
          status: "pending",
          customer_name: "creator 1",
          customer_email: "john@gmail.com",
          customer_address: "123 5th ave",
          cc_number: "12312312312",
          cc_expiration: "2019-10-10",
          cc_ccv: "907",
          zip_code: "98101"
        }
      }
      patch order_path(order), params: order_data
      order = Order.first
      order.customer_email.must_equal "john@gmail.com"
    end

    it "don't place order when not all the required fields are filled in" do
      order = Order.last
      invalid_order_data = {
        id: order.id,
        order: {
          status: "pending",
          customer_name: "creator 2",
          customer_email: "",
          customer_address: "",
          cc_number: "",
          cc_expiration: "",
          cc_ccv: "",
          zip_code: ""
        }
      }
      patch order_path(order), params: invalid_order_data
      order = Order.last
      order.customer_name.wont_equal "creator 2"
    end

    it "reduces the stock of the product by placing an order" do
      order = orders(:two)
      order_data = {
        id: order.id,
        order: {
          status: "pending",
          customer_name: "creator 323",
          customer_email: "john@gmail.com",
          customer_address: "123 5th ave",
          cc_number: "12312312312",
          cc_expiration: "2019-10-10",
          cc_ccv: "907",
          zip_code: "98101"
        }
      }
      order_item = order_items(:oi3)
      start_stock = order_item.product.stock

      patch order_path(order), params: order_data

      order = Order.find(order.id)
      order_item = OrderItem.find(order_item.id)

      end_stock = order_item.product.stock
      quantity = order_item.quantity

      (start_stock - end_stock).must_equal quantity
    end
  end
end
