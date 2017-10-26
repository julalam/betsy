require "test_helper"

describe OrderItemsController do
  describe "create" do
    it "creates a new order_item in the DB with valid data and puts it in a new order if there is not a pending order" do
      #Arrange
      order_data = {
        order_item: {
          #order: orders(:one),
          product: products(:one),
          quantity: 1
        }
      }
      start_order_item_count = OrderItem.count
      new_order_item = OrderItem.new(order_data[:order_item])
      #new_order_item.must_be :valid? --Not valid yet b/c order has not been set.  It is set within create

      #Act
      post order_items_path, params: order_data
      #Assert
      puts "new_order_item.order_id"
      puts new_order_item.order_id
      new_order_item.order_id.wont_equal nil
      must_respond_with :redirect
      must_redirect_to order_items_path
      OrderItem.count.must_equal start_order_item_count + 1
    end

    # Arrange
      #     book_data = {
      #       book: {
      #         title: "Test book",
      #         author_id: Author.first.id
      #       }
      #     }
      #     # Test data should result in a valid book, otherwise
      #     # the test is broken
      #     Book.new(book_data[:book]).must_be :valid?
      #
      #     start_book_count = Book.count
      #
      #     # Act
      #     post books_path, params: book_data
      #
      #     # Assert
      #     must_respond_with :redirect
      #     must_redirect_to books_path
      #
      #     Book.count.must_equal start_book_count + 1
      #   end


    it "creates a new order_item with valid data and puts it in a old order it there is already a pending order" do
      OrderItem.destroy_all
      start_orders = Order.count
      order_data1 = {
        order_item: {
          order: orders(:one),
          product: products(:one),
          quantity: 1
        }
      }
      OrderItem.create(order_data1[:order_item])
      post order_items_path, params: order_data1
      order_id_first = Order.first.id

      order_data2 = {
        order_item: {
          order: orders(:one),
          product: products(:two),
          quantity: 1
        }
      }
      OrderItem.create(order_data2[:order_item])

      post order_items_path, params: order_data2
      #must_redirect_to order_items_path
      Order.count.must_equal start_orders +1
      OrderItem.count.must_equal 2
    end

    it "updates a order_item with additional quantity if given a repeated order_item, within the same order" do

      #I am trying to get two orderitems for the same product to consolodate into one order item
      OrderItem.destroy_all
      start_orders = Order.count
      order_data1 = {
        order_item: {
          order: orders(:one),
          product: products(:one),
          quantity: 1
        }
      }

      order_item1 = OrderItem.create(order_data1[:order_item])
      post order_items_path, params: order_data1
      order_id_first = Order.first.id

      order_data2 = {
        order_item: {
          order: orders(:one),
          product: products(:one),
          quantity: 1
        }
      }

      OrderItem.create(order_data2[:order_item])
      post order_items_path, params: order_data2
      #must_redirect_to order_items_path
      Order.count.must_equal start_orders + 1
      #OrderItem.count.must_equal 1
      order_item1.quantity.must_equal 2
    end

    #TODO: it "updates a order_item with max quantity in stock if given a repeated order_item that requests more quantity than is in stock, within the same pending order" do
    #end

  it "does not you to create an order item for a  a retired item" do
    start_count = OrderItem.count

      order_data1 = {
        order_item: {
          order: orders(:one),
          product: products(:ninty),
          quantity: 1
        }
      }

      OrderItem.new(order_data1[:order_item])
      post order_items_path, params: order_data1
      flash[:status].must_equal :failure
      OrderItem.count.must_equal start_count
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

#TODO: do I need to do tests for the private methods?  Should these methods even be in the controller?

end
