require "test_helper"

describe ProductsController do
  # describe "controller functions" do
  #   it "tests index by merchant method" do
  #     get products_merchant_path(Merchant.first.id)
  #     must_respond_with :success
  #   end
  #
  #   it "tests index by category method " do
  #     get products_category_path(Category.first.id)
  #     must_respond_with :success
  #   end
  # end

  describe "require a user to be logged in" do
    before do
      @merchant = merchants(:eva)
      login(@merchant)
    end

    describe "new" do
      it "you can create a product if you are logged in" do
        get new_product_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "any logged in user can create a product with valid data" do
        product_data = {
          product: {
            name: "test product",
            price: 20,
            stock: 3,
            merchant_id: merchants(:eva).id
          }
        }
        start_count = Product.count
        new_product = Product.new(product_data[:product])
        new_product.must_be :valid?

        post products_path, params: product_data
        must_respond_with :redirect
        flash[:status].must_equal :success
        must_redirect_to merchant_products_path(session[:merchant_id])
        Product.count.must_equal start_count + 1
      end

      it "any logged in user can not create a product with bogus data" do
        product_data = {
          product: {
            name: "test product",
            stock: 3,
            merchant_id: merchants(:eva).id
          }
        }
        start_count = Product.count
        new_product = Product.new(product_data[:product])
        new_product.wont_be :valid?

        post products_path, params: product_data
        flash[:status].must_equal :failure
        flash[:message].must_equal "Could not create new product test product"
        Product.count.must_equal start_count
      end
    end

    describe "index" do
      it "a logged in user can see their products" do

      end
    end

    #TODO it "a logged in user can see their products organized by category" do
    #end

    describe "edit" do
      it "if you are the wrong logged in user, you can not edit another person's products" do
        merchant = merchants(:emma)
        get edit_product_path(merchant.id)
        must_redirect_to root_path
        flash[:message].must_equal "Failure: You cannot access account pages for other users"
        flash[:status].must_equal :failure
      end
    end
  end

  describe "require the correct logged in user" do
    before do
      @merchant = merchants(:eva)
      login(@merchant)
    end

    describe "edit" do
      it "if you are the correct logged in user, you can edit your own products" do
        @product = products(:one)
        get edit_product_path(@product.id)
        must_respond_with :success
      end
    end

    describe "index" do
      #TODO it "a logged in user can see their own products" do
      #end

      #TODO it "a logged in user can see their own products organized by category" do
      #end

    end

    #update
    #index
  end

  describe "all users can do these things" do
    describe "edit" do
      it "if you are not logged in, you can not edit products" do
        merchant = merchants(:emma)
        get edit_product_path(merchant.id)
        must_redirect_to root_path
        flash[:message].must_equal "You must be logged in to do that"
        flash[:status].must_equal :failure
      end
    end

    describe "new" do
      it "if you are not logged in, you can not make a new products" do
        merchant = merchants(:emma)
        get new_product_path(merchant.id)
        must_redirect_to root_path
        flash[:message].must_equal "You must be logged in to do that"
        flash[:status].must_equal :failure
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
    end

    describe "index_by_merchant" do
      it "a user can see all the products for one merchant" do
        merchant_id = Merchant.last.id
        get products_merchant_path(merchant_id)
        must_respond_with :success
      end
    end

    describe "index_by_category" do
      it "a user can see all the products for one merchant" do
        category_id = Category.last.id
        get products_category_path(category_id)
        must_respond_with :success
      end
    end

    describe "show" do
      it "any user can see a products show page" do
        product_id = Product.last.id
        get product_path(product_id)
        must_respond_with :success
      end

      it "any user cannot see a bogus products show page" do
        product_id = Product.last.id + 1
        get product_path(product_id)
        must_respond_with :not_found
      end
    end
  end
end
#
#
#
#     it "a user can see all the products in one category" do
#       product_data = {
#         product: {
#           name: "test product",
#           stock: 3,
#           #merchant_id: merchants(:eva).id,
#           category_id: Category.last.id
#         }
#       }
#       get products_path(product_data[:product])
#       must_respond_with :success
#     end
#
#     it "a user cannot see products in bogus category" do
#       product_data = {
#         product: {
#           name: "test product",
#           stock: 3,
#           #merchant_id: merchants(:eva).id,
#           category_id: Category.last.id + 1
#         }
#       }
#       #category_id = Category.last.id + 1
#       get products_path(product_data[:product])
#       must_respond_with :Found
#     end
#
#     it "a user can see all products for one merchant" do
#       product_data = {
#         product: {
#           name: "test product",
#           stock: 3,
#           merchant_id: merchants(:eva).id,
#           #category_id: Category.last.id
#         }
#       }
#       get products_path(product_data[:product])
#       must_respond_with :success
#     end
#
#
#   end
#
#
#
#   #index
#   #index_by_merchant
#   #index_by_category
# end
#
# #
# #   describe "edit" do
# #     it "succeeds for an extant product ID" do
# #       get edit_product_path(Product.first)
# #       must_respond_with :success
# #     end
# #
# #     it "renders 404 not_found for a bogus product ID" do
# #       bogus_product_id = Product.last.id + 1
# #       get edit_product_path(bogus_product_id)
# #       must_respond_with :not_found
# #     end
# #   end
# #
# #   describe "create" do
# #     it "creates a product with valid data" do
# #       product_data = {
# #         product: {
# #           name: "test product",
# #           price: 2.0,
# #           stock: 3,
# #           description: "testing",
# #           image_url: "http://via.placeholder.com/300x250",
#         }
#       }
#       new_product = Product.new(product_data[:product])
#       new_product[:retired] = false
#       new_product[:merchant_id] = session[:merchant_id]
#       new_product.must_be :valid?
#
#       start_count = Product.count
#
#       post products_path, params: product_data
#       must_respond_with :redirect
#       must_redirect_to merchant_products_path(session[:merchant_id])
#       Product.count.must_equal start_count + 1
#     end
#
#     it "renders bad_request and does not update the database for bogus data" do
#       product_data = {
#         product: {
#           name: ""
#         }
#       }
#       Product.new(product_data[:product]).wont_be :valid?
#
#       start_count = Product.count
#
#       post products_path, params: product_data
#
#       must_respond_with :bad_request
#       Product.count.must_equal start_count
#     end
#   end
#
#   describe "update" do
#     it "succeeds for valid data and an valid product ID" do
#       product = Product.first
#
#       product_data = {
#         product: {
#           name: "test product",
#           price: 2.0,
#           stock: 3,
#           description: "testing",
#           image_url: "http://via.placeholder.com/300x250",
#         }
#       }
#       product.update_attributes(product_data[:product])
#       product.must_be :valid?
#       patch product_path(product), params: product_data
#
#       must_redirect_to merchant_products_path(session[:merchant_id])
#       Product.find(product.id).name.must_equal product_data[:product][:name]
#     end
#
#     it "renders bad_request for bogus data" do
#       product = Product.first
#       product_data = {
#         product: {
#           name: ""
#         }
#       }
#       product.update_attributes(product_data[:product])
#       product.wont_be :valid?
#       patch product_path(product), params: product_data
#
#       must_respond_with :bad_request
#     end
#
#     it "renders 404 not_found for a bogus product ID" do
#
#       bogus_product_id = Product.last.id + 1
#       get product_path(bogus_product_id)
#       must_respond_with :not_found
#     end
#   end
# end
#
#
# describe "show" do
#   it "succeeds for an valid product ID" do
#     get product_path(Product.first)
#     must_respond_with :success
#   end
#
#   it "renders 404 not_found for a bogus product ID" do
#     bogus_product_id = Product.last.id + 1
#     get product_path(bogus_product_id)
#     must_respond_with :not_found
#   end
# end
#
#
# describe "index" do
#   it "returns success for all products" do
#     get products_path
#     must_respond_with :success
#   end
#
#   it "returns success for no products" do
#     Product.destroy_all
#     get products_path
#     must_respond_with :success
#   end
#
#   it "returns success and products sorted by category when passed category_id" do
#     category = Category.first
#     get category_products_path(category.id)
#     must_respond_with :success
#   end
#
#   it "does not allow a user who does not own the products to see the products" do
#     bogus_id = Merchant.last.id + 1
#     session = {}
#     session[:merchant_id] = nil
#     params = {
#       merchant_id: bogus_id
#     }
#
#     get products_path(params)
#     must_redirect_to root_path
#     flash[:status].must_equal :failure
#     flash[:message].must_equal "Failure: You cannot access account pages for other users"
#   end
#
#   it "allows merchant who does own the products to see the products" do
#     session = {}
#     session[:merchant_id] = merchants(:eva).id
#     params = {
#       merchant_id: merchants(:eva).id,
#       product_id: products(:one).id,
#
#     }
#
#     get products_path(params)
#     must_respond_with :success
#
#   end
#
# end
#
# ##I give up for right now
# describe "create" do
#   it "creates a product with valid data" do
#     product_data = {
#       product: {
#         name: "mug",
#         price: 2.0,
#         stock: 3,
#         retired: false,
#         description: "testing",
#         image_url: "http://www.fillmurray.com/",
#         merchant: merchants(:eva)
#       }
#     }
#     new_product = Product.new(product_data[:product])
#     new_product.must_be :valid?
#
#     start_count = Product.count
#
#     post products_path, params: product_data
#     must_redirect_to product_path(Product.last)
#     Product.count.must_equal start_count + 1
#   end
#
#
#   it "renders bad_request and does not update the DB for bogus data" do
#     product_data = {
#       product: {
#         name: ""
#       }
#     }
#     start_count = Product.count
#
#     post products_path, params: product_data
#
#     must_respond_with :bad_request
#     Product.count.must_equal start_count
#   end
# end
#
#
# describe "update" do
#   it "succeeds for valid data and an valid product ID" do
#     product = Product.first
#
#     product_data = {
#       product: {
#         name: "mug",
#         price: 2.0,
#         stock: 3,
#         retired: false,
#         description: "testing",
#         image_url: "http://www.fillmurray.com/",
#         merchant: Merchant.last
#       }
#     }
#     product.update_attributes(product_data[:product])
#     product.must_be :valid?
#     patch product_path(product), params: product_data
#
#     must_redirect_to product_path(product)
#     Product.find(product.id).name.must_equal product_data[:product][:name]
#   end
#
#   it "returns success and products sorted by merchant when passed merchant_id" do
#     merchant = Merchant.first
#     get merchant_products_path(merchant.id)
#     must_respond_with :success
#   end
#
#   it "returns success and products sorted by merchant and category when passed merchant_id and category_id" do
#     merchant = Merchant.first
#     category = Category.first
#     get merchant_category_products_path(merchant.id, category.id)
#     must_respond_with :success
#   end
# end
# end
