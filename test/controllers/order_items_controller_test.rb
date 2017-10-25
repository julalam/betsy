require "test_helper"

describe OrderItemsController do
  describe "require login methods" do
    before do
      @merchant = merchants(:eva)
      login(@merchant)
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth
    end

    describe "create" do
      it "creates a new order item with valid data" do
        @test = merchants(:no_orders)
        login(@test)
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth

        session = {order_id: 1}

        order = order_items(:zero)
        order_data = {
          order_item: {
            order_id: order.id,
            product_id: order.product_id,
            quantity: order.quantity
          }
        }


        #new_order_item = OrderItem.new(order_data[:order_item])
        post order_items_path, order_data, session
        must_redirect_to order_items_path
      end
    end
  end
end
=begin
    describe "index" do
      it "succeeds when there are order items" do
        get order_items_path
        must_respond_with :success
      end

      it "succeeds when there are no order items" do
        OrderItem.destroy_all
        get order_items_path
        must_respond_with :success
      end
    end

    describe "update" do
      it "updates an existing order" do
        order = OrderItem.first

        order_data = {
          order_item: {
            order_id: order.order_id,
            product_id: order.product_id,
            quantity: order.quantity - 1
          }
        }

        #order.update_attributes(product_data[:order_item])
        #order.must_be :valid?

        patch order_item_path(order), params: order_data
        must_redirect_to redirect_back

      end
    end

    describe "destroy" do
      it "succeeds for an extant order item ID" do
        order_item_id = OrderItem.first
        id = order_item_id.id
        delete order_item_path(order_item_id)
        OrderItem.where(id: id).must_be_nil
        must_redirect_to root_path
      end

      it "fails for a non extant order item ID" do
        order_item = OrderItem.new()


        delete order_item_path(order_item.id)
        OrderItem.find(order_item_id.id).must_be_nil
        must_redirect_to root_path
      end
    end
=end
