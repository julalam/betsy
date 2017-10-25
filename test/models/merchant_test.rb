require "test_helper"

describe Merchant do
  describe "relations" do
    before do
      @merchant1 = merchants(:eva)
      @merchant2 = merchants(:emma)
    end

    it "has a username" do
      @merchant1.must_respond_to :username
      @merchant1.username.must_be_kind_of String
    end

    it "has an email" do
      @merchant1.must_respond_to :email
      @merchant1.email.must_be_kind_of String
    end

    it "has a provider" do
      @merchant1.must_respond_to :provider
      @merchant1.provider.must_be_kind_of String
    end

    it "has an uid" do
      @merchant1.must_respond_to :uid
      @merchant1.uid.must_be_kind_of Integer
    end
  end

  describe 'validations' do
    it 'allows a new merchant to be created' do
      new_merchant = Merchant.new(username: 'new merchant',
                                  email: 'new@email.com',
                                  provider: 'new provider',
                                  uid: 12345)
      new_merchant.must_be :valid?
    end

    it 'does not allow invalid merchant to be created' do
      new_merchant = Merchant.new(email: 'new@email.com',
                                  provider: 'new provider')
      new_merchant.wont_be :valid?
    end
  end


  describe "custom methods" do
    # describe 'from_auth_hash' do
    #   hash = {"uid" => 12345,
    #           "info" => {
    #                 "email" => "test@email.com",
    #                 "nickname" => "nickname"
    #                 }
    #           }
    #
    #   @merchant = Merchant.from_auth_hash("provider1", hash)
    #
    # #  @merchant.must_be_kind_of Merchant
    # end

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
        Product.create(name: "new_product", price: 10, merchant: merchants(:emma))
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
        Product.create(name: "new_product", price: 10, merchant: merchants(:emma))
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
        Product.create(name: "new_product", price: 10, merchant: merchants(:emma))
        Product.create(name: "another_new_product", price: 15, merchant: merchants(:emma))
        new_products = Product.new_products(2)
        new_products.first.created_at.must_be :>, new_products.last.created_at
      end
    end

    describe "order_items_quantity" do
      # eva has two order items each with a quantity of 2 and a price of 2 and 3, respectively.
      it "returns total quantity of a merchant's order items" do
        merchants(:eva).order_items_quantity.must_equal 4
      end

      it "returns 0 for a merchant with no order items" do
        merchants(:no_orders).order_items_quantity.must_equal 0
      end


    end

    describe "order_items_total" do
      # eva has two order items each with a quantity of 2 and a price of 2 and 3, respectively.
      it "returns sum of a merchant's order items" do
        merchants(:eva).order_items_total.must_equal 10
      end

      it "returns 0 for a merchant with no order items" do
        merchants(:no_orders).order_items_quantity.must_equal 0
      end
    end

    describe "order_items_by_status" do
      before do
        @order_items = merchants(:eva).order_items_by_status("paid")
      end

      it "must return an array" do
        @order_items.must_be_kind_of Array
      end

      it "returns all order_items with the same order status" do
        statuses = @order_items.map { |order_item| order_item.order.status }
        statuses.uniq.must_equal [statuses.first]
      end
    end

    describe "revenue_by_status" do
      before do
        @order_items_paid = merchants(:eva).order_items_by_status("paid")
        @order_items_pending = merchants(:eva).order_items_by_status("pending")
      end

      it "returns right numbers" do
        (Merchant.revenue_by_status(@order_items_paid) + Merchant.revenue_by_status(@order_items_pending)).must_equal merchants(:eva).order_items_total
      end
    end

  end

end
