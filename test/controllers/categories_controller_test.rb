require "test_helper"

describe CategoriesController do
  describe "Logged in merchants" do
    before do
      @merchant = Merchants(:eva)
      login(@merchant)
    end
  end

  # describe "new" do
  #   it "gets new and returns a success status for the new page" do
  #     get new_category_path
  #     must_respond_with :success
  #   end
  # end

  describe "index" do
    it "succeeds when there are products" do
      get merchant_categories_path(@merchant.id)
      must_respond_with :success
    end

    it "succeeds when there are no products" do
      Product.destroy_all
      get merchant_categories_path(@merchant.id)
      must_respond_with :success
    end
  end

  # describe "show" do
  #   it "succeeds for an valid product ID" do
  #     get product_path(Category.first)
  #     must_respond_with :success
  #   end
  #
  #   it "renders 404 not_found for a bogus product ID" do
  #     bogus_product_id = Category.last.id + 1
  #     get product_path(bogus_product_id)
  #     must_respond_with :not_found
  #   end
  # end

  # describe "create" do
  #   it "redirects to root page when the category data is valid" do
  #     category_data = {
  #       category: {
  #         name: "mugs",
  #       }
  #     }
  #
  #     Category.new(category_data[:category]).must_be :valid?
  #     test_category = Category.create!(category_data[:category])
  #
  #     start_category_count = Category.count
  #
  #     proc {
  #       post categories_path, params: category_data
  #     }.must_change 'Category.count', 1
  #
  #
  #     ####CHANGE REDIRECT TO PATH WHEN PAGE IS CREATED
  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #     flash[:message].must_equal "Successfully created category: #{test_category.name}"
  #     flash[:status].must_equal :success
  #
  #     Category.count.must_equal start_category_count + 1
  #   end
  #
  #   it "sends bad_request when the category data is invalid" do
  #     # this data is not valid because there is no name
  #     invalid_category_data = {
  #       category: {
  #         name: ""
  #       }
  #     }
  #
  #     # makes sure test breaks if we change the model (i.e., test data no longer vaild)
  #     Category.new(invalid_category_data[:category]).wont_be :valid?
  #
  #     start_category_count = Category.count
  #
  #     #Act
  #     proc {
  #       post categories_path, params: invalid_category_data
  #     }.must_change 'Category.count', 0
  #
  #
  #     #Assert
  #     must_respond_with :bad_request
  #     flash[:message].must_equal "Could not create category"
  #     flash[:status].must_equal :failure
  #
  #     Category.count.must_equal start_category_count
  #   end
  # end
end
