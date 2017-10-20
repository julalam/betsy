require "test_helper"

describe ProductsController do

  describe "new" do
    it "works" do
      get new_product_path
      must_respond_with :success
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

  describe "index" do
    it "succeeds when there are products" do
      get products_path
      must_respond_with :success
    end

    it "succeeds when there are no products" do
      Product.destroy_all
      get products_path
      must_respond_with :success
    end
  end

##I give up for right now
  describe "create" do
    it "creates a product with valid data" do
      product_data = {
        product: {
          name: "mug",
          price: 2.0,
          stock: 3,
          retired: false,
          description: "testing",
          image_url: "http://www.fillmurray.com/",
          merchant: merchants(:eva)
        }
      }
      start_count = Product.count

      post products_path, params: product_data
#binding.pry
      must_redirect_to product_path(Product.last)
      Product.count.must_equal start_count + 1
    end

    it "renders bad_request and does not update the DB for bogus data" do
      product_data = {
        product: {
          name: ""
        }
      }
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
          name: "mug",
          price: 2.0,
          stock: 3,
          retired: false,
          description: "testing",
          image_url: "http://www.fillmurray.com/",
          merchant: Merchant.last
        }
      }

      patch product_path(product), params: product_data

      must_redirect_to product_path(product)
      Product.find(product.id).name.must_equal product_data[:product][:name]
    end

    it "renders bad_request for bogus data" do
      product = Product.new(name: "thneed", price: 2.0, stock: 3, retired: false, description: "testing", image_url: "http://www.fillmurray.com/", merchant: merchants(:eva))

      product = Product.first
      product_data = {
        product: {
          name: ""
        }
      }
      start_count = Product.count

      patch product_path(product), params: product_data

      must_respond_with :bad_request
      Product.count.must_equal start_count
    end

    it "renders 404 not_found for a bogus product ID" do

      bogus_product_id = Product.last.id + 1
      get product_path(bogus_product_id)
      must_respond_with :not_found
    end
  end



end
