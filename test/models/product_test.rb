require "test_helper"

describe Product do
  describe "relations" do
    before do
      @product = products(:one)
    end

    it "has a merchant" do
      @product.must_respond_to :merchant
      @product.merchant.must_be_kind_of Merchant
    end

    it "has a list of order_items" do
      @product.must_respond_to :order_items
      @product.order_items.each do |order_item|
        order_item.must_be_kind_of OrderItem
      end
    end

    it "has and belongs to many categories" do
      @product.must_respond_to :categories
      @product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end

    it "has many reviews" do
      @product.must_respond_to :reviews
      @product.reviews.each do |review|
        review.must_be_kind_of Review
      end
    end

    it "has many orders" do
      @product.must_respond_to :orders
      @product.orders.each do |order|
        order.must_be_kind_of Order
      end
    end
  end

  describe "validations" do

    it "allows a product to be created with name and price" do
      product = Product.new(name: "new_product", price: 10, merchant: merchants(:emma), stock: 5000)

      product.must_be :valid?
    end

    it "requires a name to be created" do
      product = Product.new(price: 10, merchant: merchants(:emma), stock: 5000)

      product.wont_be :valid?
    end

    it "requires a unique name to be created" do
      product_1 = Product.create(name: "new_product", price: 10, merchant: merchants(:emma), stock: 5000)
      product_2 = Product.new(name: "new_product", price: 10, merchant: merchants(:emma), stock: 5000)

      product_2.wont_be :valid?
    end

    it "requires a price to be created" do
      product = Product.new(name: "new_product", merchant: merchants(:emma), stock: 5000)

      product.wont_be :valid?
    end

    it "requires the price be greater than 0" do

      product_0 = Product.new(name: "new_product", price: 0, merchant: merchants(:emma), stock: 5000)

      product_less_than_0 = Product.new(name: "new_product", price: -10, merchant_id: (:emma), stock: 5000)

      product_ten = Product.new(name: "new_product", price: "ten", merchant: merchants(:emma), stock: 5000)

      product_0.wont_be :valid?
      product_less_than_0.wont_be :valid?
      product_ten.wont_be :valid?
    end


    it "cannot be created without stock" do
      invalid_prod = Product.new(name: "test", price: 3000, merchant: merchants(:emma))
      invalid_prod.wont_be :valid?
      invalid_prod.errors.messages.must_include :stock
    end

    it "cannot be created with a float" do
      invalid_prod = Product.new(name: "test", price: 3000, merchant: merchants(:emma), stock: 3.4)
      invalid_prod.wont_be :valid?
      invalid_prod.errors.messages.must_include :stock
    end


    it "cannot be created with a stock of 0" do
      invalid_prod = Product.new(name: "test", price: 3000, merchant: merchants(:emma), stock: 0)
      invalid_prod.wont_be :valid?
      invalid_prod.errors.messages.must_include :stock
    end

    it "cannot be created with a negative quantity" do
      invalid_prod = Product.new(name: "test", price: 3000, merchant: merchants(:emma), stock: -5)
      invalid_prod.wont_be :valid?
      invalid_prod.errors.messages.must_include :stock
    end
  end

  describe "custom methods" do
    describe "random_products"  do
      it "must return an array of asked length of products" do
        rand_products = Product.random_products(6)
        rand_products.must_be_kind_of Array
        rand_products.length.must_equal 6
      end

      it "must return empty array if there are no products" do
        Product.destroy_all
        rand_products = Product.random_products(6)
        rand_products.must_be_kind_of Array
        rand_products.length.must_equal 0
      end

      it "must return all products if there are less products that it was asked in random method" do
        Product.destroy_all
        Product.create(name: "new_product", price: 10, merchant: merchants(:emma), retired: false, stock: 4)
        rand_products = Product.random_products(6)
        rand_products.must_be_kind_of Array
        rand_products.length.must_equal 1
      end

      it "must return new products every time" do
        rand_products_1 = Product.random_products(6)
        rand_products_2 = Product.random_products(6)
        rand_products_1.wont_equal rand_products_2
      end
    end

    describe "new_products" do
      it "must return a list of product with asked length if there are more products than it was asked" do
        new_products = Product.new_products(5)
        new_products.must_be_kind_of Array
        new_products.length.must_equal 5
      end

      it "must return empty array if there are no products" do
        Product.destroy_all
        new_products = Product.new_products(5)
        new_products.must_be_kind_of Array
        new_products.length.must_equal 0
      end

      it "must return all products if there are less products that it was asked in new method" do
        Product.destroy_all
        Product.create(name: "new_product", price: 10, merchant: merchants(:emma), retired: false, stock: 1)
        new_products = Product.new_products(5)
        new_products.must_be_kind_of Array
        new_products.length.must_equal 1
      end

      it "must return same products every time" do
        new_products_1 = Product.new_products(5)
        new_products_2 = Product.new_products(5)
        new_products_1.must_equal new_products_2
      end

      it "must return products in the right order" do
        Product.destroy_all
        Product.create(name: "new_product", price: 10, merchant: merchants(:emma), retired: false, stock: 4)
        Product.create(name: "another_new_product", price: 15, merchant: merchants(:emma), retired: false, stock: 7)
        new_products = Product.new_products(2)
        new_products.first.created_at.must_be :>, new_products.last.created_at
      end
    end

    describe "average_rating" do
      before do
        @product = products(:one)
        @ratings = []
        @product.reviews.each do |review|
          @ratings << review.rating
        end
      end

      it "must return an integer" do
        @product.average_rating.must_be_kind_of Integer
      end

      it "must return correct average rating for list of reviews" do
        @product.average_rating.must_equal @ratings.inject{ |sum, el| sum + el } / @ratings.length
      end
    end

    # describe "bestseller" do
    #   before do
    #     Order.destroy_all
    #     @product_1 = products(:one)
    #     @product_2 = products(:two)
    #     @product_3 = products(:three)
    #
    #     #
    #     # customer_data = {
    #     #   customer_name: "customer",
    #     #   customer_email: "customer@email.com",
    #     #   customer_address: "address",
    #     #   cc_number: 1234,
    #     #   cc_expiration: Date.today,
    #     #   cc_ccv: 123,
    #     #   zip_code: 12345
    #     # }
    #
    #     @order1 = Order.create!(status: 'paid', customer_name: 'Sue', customer_email: 'Sue@gmail.com', customer_address:'123 internet street', cc_number: '123123123', cc_expiration: '2020-10-01', cc_ccv: '980', zip_code: '98101')
    #     @order2 = Order.create!(status: 'paid', customer_name: 'Suzie', customer_email: 'Sue@gmail.com', customer_address:'123 internet street', cc_number: '123123123', cc_expiration: '2020-10-01', cc_ccv: '980', zip_code: '98101')
    #     @order3 = Order.create!(status: 'pending', customer_name: 'Susie', customer_email: 'Sue@gmail.com', customer_address:'123 internet street', cc_number: '123123123', cc_expiration: '2020-10-01', cc_ccv: '980', zip_code: '98101')
    #
    #     OrderItem.create!(order_id: @order1.id, product_id: @product_1.id, quantity: 2)
    #     OrderItem.create!(order_id: @order1.id, product_id: @product_1.id, quantity: 5)
    #     OrderItem.create!(order_id: @order1.id, product_id: @product_1.id, quantity: 8)
    #     OrderItem.create!(order_id: @order2.id, product_id: @product_1.id, quantity: 2)
    #
    #   end
    #
    #   it "must return an array" do
    #     @product_1.orders.length.must_equal 1
    #     @product_2.orders.length.must_equal 2
    #     @product_3.orders.length.must_equal 3
    #
    #     Order.bestseller.must_be_kind_of Array
    #     Order.bestseller.first.must_be_kind_of Products
    #   end
    # end
  end
end
