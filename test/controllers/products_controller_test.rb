require "test_helper"

describe ProductsController do
  describe "require login methods" do
    before do
      @merchant = merchants(:eva)
      login(@merchant)
    end

    describe "new" do
      it "returns success" do
        get new_product_path
        must_respond_with :success
      end
    end

    describe "edit" do
      it "succeeds for an extant product ID" do
        get edit_product_path(Product.first)
        must_respond_with :success
      end

      it "renders 404 not_found for a bogus product ID" do
        bogus_product_id = Product.last.id + 1
        get edit_product_path(bogus_product_id)
        must_respond_with :not_found
      end
    end

    describe "create" do
      it "creates a product with valid data" do
        product_data = {
          product: {
            name: "test product",
            price: 2.0,
            stock: 3,
            description: "testing",
            image_url: "http://via.placeholder.com/300x250",
          }
        }
        new_product = Product.new(product_data[:product])
        new_product[:retired] = false
        new_product[:merchant_id] = session[:merchant_id]
        new_product.must_be :valid?

        start_count = Product.count

        post products_path, params: product_data
        must_respond_with :redirect
        must_redirect_to merchant_products_path(session[:merchant_id])
        Product.count.must_equal start_count + 1
      end

      it "renders bad_request and does not update the data base for bogus data" do
        product_data = {
          product: {
            name: ""
          }
        }
        Product.new(product_data[:product]).wont_be :valid?

        start_count = Product.count

        post products_path, params: product_data

        must_respond_with :bad_request
        Product.count.must_equal start_count
      end
    end

    describe "update" do
      it "succeeds for valid data and an valid product ID" do
        product = Product.first

        product_data = {
          product: {
            name: "test product",
            price: 2.0,
            stock: 3,
            description: "testing",
            image_url: "http://via.placeholder.com/300x250",
          }
        }
        product.update_attributes(product_data[:product])
        product.must_be :valid?
        patch product_path(product), params: product_data

        must_redirect_to merchant_products_path(session[:merchant_id])
        Product.find(product.id).name.must_equal product_data[:product][:name]
      end

      it "renders bad_request for bogus data" do
        product = Product.first
        product_data = {
          product: {
            name: ""
          }
        }
        product.update_attributes(product_data[:product])
        product.wont_be :valid?
        patch product_path(product), params: product_data

        must_respond_with :bad_request
      end

      it "renders 404 not_found for a bogus product ID" do

        bogus_product_id = Product.last.id + 1
        get product_path(bogus_product_id)
        must_respond_with :not_found
      end
    end
  end


  describe "show" do
    it "succeeds for an valid product ID" do
      get product_path(Product.first)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus product ID" do
      bogus_product_id = Product.last.id + 1
      get product_path(bogus_product_id)
      must_respond_with :not_found
    end
  end


  describe "index" do
    it "returns success for all products" do
      get products_path
      must_respond_with :success
    end

    it "returns success for no products" do
      Product.destroy_all
      get products_path
      must_respond_with :success
    end

    it "returns success and products sorted by category when passed category_id" do
      category = Category.first
      get category_products_path(category.id)
      must_respond_with :success
    end

    it "returns success and products sorted by merchant when passed merchant_id" do
      merchant = Merchant.first
      get merchant_products_path(merchant.id)
      must_respond_with :success
    end

    it "returns success and products sorted by merchant and category when passed merchant_id and category_id" do
      merchant = Merchant.first
      category = Category.first
      get merchant_category_products_path(merchant.id, category.id)
      must_respond_with :success
    end
  end
end
