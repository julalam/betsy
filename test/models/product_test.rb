require "test_helper"

###None of this is working yet.
#problems to solve:
#1. Where are the layouts
#2. There is something wrong with the strong params


describe Product do
  describe "relations" do

    #this is failing. I don't know why.
    it "has a merchant" do
      thneed = products(:one)

      puts thneed.merchant_id
      puts "***************"
      puts merchants(:eva).id

      thneed.must_respond_to :merchant
      thneed.merchant.must_be_kind_of Merchant
    end

    #This is failing b/c I can't make Order_items.
    #I don't know why I can't make Order_items, but
    #I am think Rebecca is working on Order_items and
    #I will wait until she has sorted more of that out to trouble shoot this.
    it "has a list of order_items" do
      thneed = products(:one)

      thneed.must_respond_to :item_order
    end
  end

  describe "validations" do

    it "allows a product to be created with a unique name and price" do
      thneed = Product.new(name: "blue_thneed", price: 10, merchant: merchants(:emma))

      thneed.valid?.must_equal true
    end

    it "requires a name to be created" do
      thneed = Product.new(price: 10, merchant: merchants(:emma))

      thneed.valid?.must_equal false
    end

    it "requires a price to be created" do
      thneed = Product.new(name: "blue_thneed", merchant: merchants(:emma))

      thneed.valid?.must_equal false
    end

    it "requires the price be greater than 0" do

      thneed_0 = Product.new(name: "blue_thneed", price: 0, merchant: merchants(:emma))

      thneed_less_than_0 = Product.new(name: "blue_thneed", price: -10, merchant_id: (:emma))

      thneed_ten = Product.new(name: "blue_thneed", price: "ten", merchant: merchants(:emma))

      thneed_0.valid?.must_equal false
      thneed_less_than_0.valid?.must_equal false
      thneed_ten.valid?.must_equal false
    end

    it "requires a unique name to be created" do
      thneed_1 = Product.create(name: "blue_thneed", price: 10, merchant: merchants(:emma))
      thneed_2 = Product.new(name: "blue_thneed", price: 10, merchant: merchants(:emma))

      thneed_2.valid?.must_equal false
    end
  end

  describe "custom methods" do
    describe "three_random_products"  do
      it "For >3 products, must return an array of 3 products" do
        rand_products = Product.three_random_products
        rand_products.must_be_kind_of Array
        rand_products.length.must_equal 3
      end

      it "For 0 to 2 products, must return an array of as many products as there are" do
        Product.destroy_all
        rand_products = Product.three_random_products
        rand_products.must_be_kind_of Array
        rand_products.length.must_equal 0

        thneed_1 = Product.create(name: "blue_thneed", price: 10, merchant: merchants(:emma))
        rand_products = Product.three_random_products
        rand_products.length.must_equal 1
      end

      it "The products selected are not the same every time" do
        rand_products_1 = Product.three_random_products
        rand_products_2 = Product.three_random_products
        rand_products_1.wont_equal rand_products_2
      end



    end


  end

end
