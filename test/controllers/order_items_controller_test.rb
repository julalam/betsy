require "test_helper"

describe OrderItemsController do
  describe "require login methods" do
    before do
      @merchant = merchants(:eva)
      login(@merchant)
    end

    describe "new" do
      it "returns success" do
        get new_order_item_path
        must_respond_with :success
      end
    end

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

        order.update_attributes(product_data[:order_item])
        order.must_be :valid?

        patch order_path(order), params: order_data
        must_redirect_to redirect_back

      end
    end

    describe "create" do
      it "creates a new order item with valid data" do
        order_data = {
          order_item: {
            order_id: 2,
            product_id: 1,
            quantity: 3
          }
        }
        new_order_item = OrderItem.new(order_data[:order_item])
        post order_items_path, params: order_data
        must_redirect_to order_items_path
      end


    end

    describe "destroy" do
      it "succeeds for an extant order item ID" do
        order_item_id = OrderItem.first

        delete order_item_path(order_item_id)
        OrderItem.find(order_item_id.id).must_be_nil
        must_redirect_to root_path
      end
    end

  end
end
