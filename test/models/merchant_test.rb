require "test_helper"

describe Merchant do
  describe "relations" do
    before do
      @merchant1 = merchants(:eva)
      @merchant2 = merchants(:emma)
    end

    it "a merchant can have a many products" do
      @merchant1.must_respond_to :products
    end

    it "a merchant can have zero products" do
      Product.destroy_all
      @merchant1.must_respond_to :products
    end

    it "a merchant can have many order_items" do
      @merchant1.must_respond_to :order_items
    end

    it "a merchant can have zero order_items" do
      OrderItem.destroy_all
      @merchant1.must_respond_to :order_items
    end

    it "a merchant can have orders" do
      @merchant1.must_respond_to :orders
    end

    it "a merchant can have zero orders" do
      Order.destroy_all
      @merchant1.must_respond_to :orders
    end
  end

  describe 'validations' do
    before do
      @merchant1 = Merchant.new(username: 'new merchant',  email: 'new@email.com', provider: 'newprovider', uid: 12345)
    end

    it 'allows a new merchant to be created' do
      @merchant1.must_be :valid?
    end

    it 'does not allow merchant to be created without a provider' do
      bogus_merchant = Merchant.new(username: 'new merchant',  email: 'new@email.com', uid: 12345)
      bogus_merchant.wont_be :valid?
      bogus_merchant.errors.messages.must_include :provider
    end

    it 'does not allow merchant to be created without a uid' do
      bogus_merchant = Merchant.new(email: 'new@email.com', provider: 'new provider')
      bogus_merchant.wont_be :valid?
      bogus_merchant.errors.messages.must_include :uid
    end

    it 'does not allow merchant to be created with an uid that is already registered' do
      @merchant1.save!
      repeat_merchant = Merchant.new(username: 'newer merchant',  email: 'newer@email.com', provider: 'newerprovider', uid: 12345)
      repeat_merchant.wont_be :valid?
      repeat_merchant.errors.messages.must_include :uid
    end

    it 'does not allow merchant to be created without a username' do
      bogus_merchant = Merchant.new(email: 'new@email.com', provider: 'newprovider', uid: 12345)
      bogus_merchant.wont_be :valid?
      bogus_merchant.errors.messages.must_include :username
    end

    it 'does not allow merchant to be created with an username that is already registered' do
      @merchant1.save!
      repeat_merchant = Merchant.new(username: 'new merchant',  email: 'newer@email.com', provider: 'newerprovider', uid: 12346)
      repeat_merchant.wont_be :valid?
      repeat_merchant.errors.messages.must_include :username
    end

    it 'does not allow merchant to be created without a email' do
      bogus_merchant = Merchant.new(username: 'new merchant', provider: 'newprovider', uid: 12345)
      bogus_merchant.wont_be :valid?
      bogus_merchant.errors.messages.must_include :email
    end

    it 'does not allow merchant to be created with an email that is already registered' do
      @merchant1.save!
      repeat_merchant = Merchant.new(username: 'newer merchant',  email: 'new@email.com', provider: 'newerprovider', uid: 12346)
      repeat_merchant.wont_be :valid?
      repeat_merchant.errors.messages.must_include :email
    end



  end


  describe "custom methods" do
    describe 'from_auth_hash' do
      it "returns a merchant when given valid data." do
        provider = "github"
        hash = {
          "uid" =>"1234",
          "info" =>{
            "nickname" => "Dan",
            "email" => "Dan@email.com"
          }
        }
        user = Merchant.from_auth_hash(provider, hash)
        user.provider.must_equal "github"
        user.uid.must_equal 1234
        user.username.must_equal "Dan"
        user.email.must_equal "Dan@email.com"
        user.must_be_kind_of Merchant
      end
    end

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
      # eva has two order items each with a quantity of 3 and 1
      it "returns total quantity of a merchant's order items" do
        merchants(:eva).order_items_quantity.must_equal 4
      end

      it "returns 0 for a merchant with no order items" do
        OrderItem.destroy_all
        merchants(:eva).order_items_quantity.must_equal 0
      end


    end

    describe "order_items_total" do
      # eva has two order items each with a quantity of 3 and 1 and a price of 2.
      it "returns sum of a merchant's order items" do
        merchants(:eva).order_items_total.must_equal 8
      end

      it "returns 0 for a merchant with no order items" do
        OrderItem.destroy_all
        merchants(:eva).order_items_quantity.must_equal 0
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
        statuses.uniq.must_equal ["paid"]
        statuses.uniq.length.must_equal 1
      end

      it "returns an empty array for no order_items wit the a given status" do
        bogus_status = merchants(:eva).order_items_by_status("bogus")
        statuses = bogus_status.map { |order_item| order_item.order.status }
        statuses.uniq.must_equal []
        statuses.uniq.length.must_equal 0
      end
    end

    describe "revenue_by_status" do
      before do
        @order_items_paid = merchants(:eva).order_items_by_status("paid")
        @order_items_pending = merchants(:eva).order_items_by_status("pending")
      end

      it "returns right numbers" do
        (Merchant.revenue_by_status(@order_items_paid) + Merchant.revenue_by_status(@order_items_pending)).must_equal merchants(:eva).order_items_total

        Merchant.revenue_by_status(@order_items_paid).must_equal 8


        #if there is time, revisit this.  We were trying to add another order_item and make sure that the revenue increased.  But it was not working...
        # order = OrderItem.new(quantity: 1, product: products(:one), order: orders(:one))
        # order.save
        #
        # puts "#{order.inspect}"
        # order_items_paid = merchants(:eva).order_items_by_status("paid")
        # puts "#{order_items_paid.inspect}"
        # Merchant.revenue_by_status(order_items_paid).must_equal 9

      end
    end
  end
end
