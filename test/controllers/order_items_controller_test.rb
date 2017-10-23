require "test_helper"

describe OrderItemsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe "index" do
    it "succeeds when there are order items" do
      OrderItem.count.must_be :>, 0, "No order items in the test fixtures"
      get order_items_path
      must_respond_with :redirect
    end

    it "succeeds when there are no order items" do
      OrderItem.destroy_all
      get order_items_path
      must_respond_with :redirect
    end
  end

  describe "destroy" do
    it "fails for the wrong merchant" do
      order_item_id = OrderItem.first.id

      delete order_item_path(order_item_id)
      must_redirect_to root_path

      OrderItem.find_by(id: order_item_id).wont_be_nil
    end
  end

  describe "create" do
    it 'makes a new order item' do


    end
  end

  describe "update" do
    it "updates an order item" do
      order = OrderItem.first

      order_params = {
        orderitem: {
          order_id: order.order_id,
          product_id: order.product_id,
          quantity: 73
        }
      }
      before = OrderItem.count
      order.update_attributes(order_params[:orderitem])
      patch order_item_path(order), params: order_params
      must_redirect_to order_item_path(order)
    end
  end


end
