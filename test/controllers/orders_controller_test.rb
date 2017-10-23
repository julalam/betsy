require "test_helper"

describe OrdersController do
  describe "login" do

    before do
      @merchant = merchants(:eva)
      login(@merchant)
    end
  end

  describe "New" do
    it "returns success" do
      get orders_path
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "works for valid order" do
      get edit_order_path(Order.first)
      must_respond_with :redirect
    end
  end

  describe "create" do
    it "makes a new order" do
      order_data = {
        order: {
          status: 'pending',
          customer_name: "billy",
          customer_email: "bill@email.com",
          customer_address: "1231 a st",
          cc_number: "12938129312",
          cc_expiration: "2017-10-15",
          cc_ccv: 123,
          zip_code: "19032"
        }
      }
      new_order = Order.new(order_data[:order])
      new_order.must_be :valid?

      start_count = Order.count

      post orders_path, params: order_data
      must_respond_with :redirect
      Order.count.must_equal start_count+1
    end

    it "does not make a bad order" do
      order_data = {
        order: {

        }
      }
      new_order = Order.new(order_data[:order])
      new_order.must_be :valid?

      start_count = Order.count

      post orders_path, params: order_data
      must_respond_with :redirect
      Order.count.must_equal start_count
    end
  end

  describe "Update" do
    it "updates a current order" do
      order = Order.first
      order_data = {
        order: {
          status: 'pending',
          customer_name: "billy",
          customer_email: "bill@email.com",
          customer_address: "1231 a st",
          cc_number: "12938129312",
          cc_expiration: "2017-10-15",
          cc_ccv: 123,
          zip_code: "19032"
        }
      }

      order.update_attributes(order_data[:order])
      order.must_be :valid?
      patch order_path(order), params: order_data
      must_redirect_to order_path(order)
    end

    it 'does not update a current order with bad data' do
      order = Order.first
      order_data = {
        order: {
          cc_number: "12938129312",
          cc_expiration: "2017-10-15",
          cc_ccv: 123,
          zip_code: "19032"
        }
      }
      before = Order.count
      order.update_attributes(order_data[:order])
      Order.count.must_equal before
    end
  end
end
