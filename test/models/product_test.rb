require "test_helper"

describe Product do
  describe "relations" do

    it "has a merchant" do
      onceler = Merchant.create
      # want_to_buy = Order_items.create
      thneed = Product.new(name: "blue_thneed", price: 10, merchant: onceler)

      thneed.must_respond_to :merchant
      thneed.merchant.must_be_kind_of Merchant
    end

    #This is failing b/c I can't make Order_items.
    #I don't know why I can't make Order_items.
    it "has a list of order_items" do
      onceler = Merchant.create
      want_to_buy = Order_item.create
      thneed = Product.new(name: "blue_thneed", price: 10, merchant: onceler, order_item: want_to_buy)

      thneed.must_respond_to :item_order
    end
  end

  describe "validations" do

    it "allows a product to be created with a unique name and price" do
      onceler = Merchant.create
      thneed = Product.new(name: "blue_thneed", price: 10, merchant: onceler)

      thneed.valid?.must_equal true
    end

    it "requires a name to be created" do
      onceler = Merchant.create
      thneed = Product.new(price: 10, merchant: onceler)

      thneed.valid?.must_equal false
    end

    it "requires a price to be created" do
      onceler = Merchant.create
      thneed = Product.new(name: "blue_thneed", merchant: onceler)

      thneed.valid?.must_equal false
    end

    it "requires the price be greater than 0" do
      onceler = Merchant.create
      thneed_0 = Product.new(name: "blue_thneed", price: 0, merchant: onceler)
      thneed_less_than_0 = Product.new(name: "blue_thneed", price: -10, merchant: onceler)
      thneed_ten = Product.new(name: "blue_thneed", price: "ten", merchant: onceler)

      thneed_0.valid?.must_equal false
      thneed_less_than_0.valid?.must_equal false
      thneed_ten.valid?.must_equal false
    end

    it "requires a unique name to be created" do
      onceler = Merchant.create
      thneed_1 = Product.create(name: "blue_thneed", price: 10, merchant: onceler)
      thneed_2 = Product.new(name: "blue_thneed", price: 10, merchant: onceler)

      thneed_2.valid?.must_equal false
    end
  end
end
