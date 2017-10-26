require "test_helper"

describe OrderItemsController do


  describe "create" do
    it "creates a new order_item in the DB with valid data and puts it in a new order if there is not a pending order" do
      OrderItem.destroy_all
      #Arrange
      #order_items start with just a product and a quantity
      order_data = {
        order_item: {
          #order: orders(:one),
          product_id: products(:one).id,
          quantity: 1,
          status: nil
        }
      }
      start_order_item_count = OrderItem.count

      #Act
      post order_items_path, params: order_data
      #When an order_item is created the cart is assigned

      #Assert
      #1. gave the order a cart
      OrderItem.first.order_id.wont_equal nil
      #2. set the session order id
      session[:order_id].must_equal OrderItem.first.order.id
      #3. sent the user to the right place
      must_respond_with :redirect
      must_redirect_to order_items_path
      #added the order item to database
      OrderItem.count.must_equal start_order_item_count + 1
    end


    it "creates a new order_item with valid data and puts it in a old order it there is already a pending order" do
      OrderItem.destroy_all
      Order.destroy_all
      #Arrange
      order_data1 = {
        order_item: {
          #order_id: orders(:one).id,
          product_id: products(:one).id,
          quantity: 1,
          status: nil
        }
      }
      order_data2 = {
        order_item: {
          #order_id: orders(:one).id,
          product_id: products(:two).id,
          quantity: 2,
          status: nil
        }
      }

      #Act
      post order_items_path, params: order_data1
      post order_items_path, params: order_data2

      #Assert
      #1. made two order items
      OrderItem.first.wont_equal OrderItem.last.quantity
      OrderItem.count.must_equal 2
      #2. put them in the same cart
      OrderItem.first.order_id.must_equal OrderItem.last.order_id
      Order.count.must_equal 1
      #3. set the session order id to that cart id
      session[:order_id].must_equal OrderItem.first.order.id
      #4. sent the user to the right place
      must_respond_with :redirect
      must_redirect_to order_items_path
    end

    it "updates a order_item with additional quantity if given a repeated order_item, within the same order" do

      OrderItem.destroy_all
      Order.destroy_all
      #Arrange
      order_data1 = {
        order_item: {
          #order_id: orders(:one).id,
          product_id: products(:one).id,
          quantity: 1,
          status: nil
        }
      }
      order_data2 = {
        order_item: {
          #order_id: orders(:one).id,
          product_id: products(:one).id,
          quantity: 2,
          status: nil
        }
      }

      #Act
      post order_items_path, params: order_data1
      post order_items_path, params: order_data2

      #Assert
      #1. made one order_item
      OrderItem.count.must_equal 1
      #2. Updated the quantity to reflect the right amount
      OrderItem.first.quantity.must_equal 3
      #3. put it(them) in the same cart
      Order.count.must_equal 1
      #4. set the session order id to that cart id
      session[:order_id].must_equal OrderItem.first.order.id
      #5. sent the user to the right place
      must_respond_with :redirect
      must_redirect_to order_items_path
    end

    it "updates a order_item with max quantity in stock if given a repeated order_item that requests more quantity than is in stock, within the same pending order" do
      OrderItem.destroy_all
      Order.destroy_all
      #Arrange
      order_data1 = {
        order_item: {
          #order_id: orders(:one).id,
          product_id: products(:one).id,
          quantity: 1,
          status: nil
        }
      }
      order_data2 = {
        order_item: {
          #order_id: orders(:one).id,
          product_id: products(:one).id,
          quantity: 100,
          status: nil
        }
      }

      #Act
      post order_items_path, params: order_data1
      post order_items_path, params: order_data2

      #Assert
      #1. made one order_item
      OrderItem.count.must_equal 1
      #2. Updated the quantity to reflect the max amount
      OrderItem.first.quantity.must_equal 3
      #3. put it(them) in the same cart
      Order.count.must_equal 1
      #4. set the session order id to that cart id
      session[:order_id].must_equal OrderItem.first.order.id
      #5. sent the user to the right place
      must_respond_with :redirect
      must_redirect_to order_items_path
    end

    it "will not create an order item with bogus data" do
      OrderItem.destroy_all
      Order.destroy_all
      #Arrange
      order_data1 = {
        order_item: {
          #order_id: orders(:one).id,
          product_id: products(:one).id,
          quantity: -1,
          status: nil
        }
      }
      #Act
      post order_items_path, params: order_data1

      #Assert
      flash[:status].must_equal :failure
      must_redirect_to root_path
    end

    #TODO:it "does not you to create an order item for a  a retired item"
    #This is no longer nessesary(?) because there is no longer a "add to cart" button on the product show page if the product is retired
    #end
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
    it "updates the quatntity of a existing order" do
      #Arrange
      OrderItem.destroy_all
      order_data = {
        order_item: {
          order: orders(:one),
          product_id: products(:one).id,
          quantity: 1,
          status: nil
        }
      }
      new_order_item = OrderItem.create!(order_data[:order_item])
      order_data_update = {
        order_item: {
          quantity: 4
        }
      }

      #Act
      patch order_item_path(new_order_item), params: order_data_update

      #Assert
      OrderItem.count.must_equal 1
      OrderItem.first.quantity.must_equal 4
      flash[:status].must_equal :success
      must_respond_with :redirect
    end

    it "does not update if attempting to update with bogus parameters" do
      #Arrange
      OrderItem.destroy_all
      order_data = {
        order_item: {
          order: orders(:one),
          product_id: products(:one).id,
          quantity: 2,
          status: nil
        }
      }
      new_order_item = OrderItem.create!(order_data[:order_item])
      order_data_update = {
        order_item: {
          order: orders(:one),
          quantity: -4
        }
      }

      #Act
      patch order_item_path(new_order_item), params: order_data_update

      #Assert
      OrderItem.count.must_equal 1
      OrderItem.first.quantity.must_equal 2
      flash[:status].must_equal :failure
      must_respond_with :redirect
    end
  end

  describe "destroy" do
    it "succeeds for an extant order item ID" do
      order_item_id = OrderItem.first
      id = order_item_id.id
      delete order_item_path(order_item_id)
      flash[:status].must_equal :success
      assert_nil OrderItem.find_by(id: id)
      must_redirect_to order_items_path
    end

    it "fails for a non extant order item ID" do
      bogus_order_item_id = OrderItem.last.id + 1

      delete order_item_path(bogus_order_item_id)
      flash[:status].must_equal :failure
      must_redirect_to order_items_path
    end
  end
end
