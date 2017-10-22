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
  end

  describe "validations" do

    it "allows a product to be created with name and price" do
      product = Product.new(name: "new_product", price: 10, merchant: merchants(:emma))

      product.must_be :valid?
    end

    it "requires a name to be created" do
      product = Product.new(price: 10, merchant: merchants(:emma))

      product.wont_be :valid?
    end

    it "requires a unique name to be created" do
      product_1 = Product.create(name: "new_product", price: 10, merchant: merchants(:emma))
      product_2 = Product.new(name: "new_product", price: 10, merchant: merchants(:emma))

      product_2.wont_be :valid?
    end

    it "requires a price to be created" do
      product = Product.new(name: "new_product", merchant: merchants(:emma))

      product.wont_be :valid?
    end

    it "requires the price be greater than 0" do

      product_0 = Product.new(name: "new_product", price: 0, merchant: merchants(:emma))

      product_less_than_0 = Product.new(name: "new_product", price: -10, merchant_id: (:emma))

      product_ten = Product.new(name: "new_product", price: "ten", merchant: merchants(:emma))

      product_0.wont_be :valid?
      product_less_than_0.wont_be :valid?
      product_ten.wont_be :valid?
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
  end
end
