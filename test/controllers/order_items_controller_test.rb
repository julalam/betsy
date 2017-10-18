require "test_helper"

describe OrderItemsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe "index" do
    it "succeeds when there are order items" do
      OrderItem.count.must_be :>, 0, "No order items in the test fixtures"
      get orderitems_path
      must_respond_with :success
    end

    it "succeeds when there are no order items" do
      OrderItem.destroy_all
      get orderitems_path
      must_respond_with :success
    end
  end
  describe "destroy" do
    it "succeeds for an extant order item ID" do
      order_item_id = OrderItem.first.id

      delete work_path(order_item_id)
      must_redirect_to root_path

      OrderItem.find_by(id: order_item_id).must_be_nil
    end

    # it "renders 404 not_found and does not update the DB for a bogus work ID" do
    #   start_count = OrderItem.count
    #
    #   bogus_order_item_id = OrderItem.last.id + 1
    #   delete work_path(bogus_order_item_id)
    #   must_respond_with :not_found
    #
    #   Work.count.must_equal start_count
    # end

  end


end
