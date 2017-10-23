require "test_helper"

describe CategoriesController do
  before do
    @merchant = merchants(:eva)
    login(@merchant)
  end

  describe "new" do
    it "gets new and returns a success status for the new page" do
      get new_merchant_category_path(@merchant.id)
      must_respond_with :success
    end
  end

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

  describe "create" do
    it "redirects to merchant categories page when the category data is valid" do
      category_data = {
        category: {
          name: "new_category",
        }
      }

      Category.new(category_data[:category]).must_be :valid?

      start_category_count = Category.count

      post categories_path, params: category_data

      must_respond_with :redirect
      must_redirect_to merchant_categories_path(@merchant.id)
      Category.count.must_equal start_category_count + 1
    end

    it "redirects to form page when given category name is not unique" do
      category_data = {
        category: {
          name: Category.first.name,
        }
      }

      Category.new(category_data[:category]).wont_be :valid?

      start_category_count = Category.count

      post categories_path, params: category_data

      must_respond_with :redirect
      must_redirect_to new_merchant_category_path(@merchant.id)
      Category.count.must_equal start_category_count
    end

    it "redirects to form page when the category data is invalid" do
      invalid_category_data = {
        category: {
          name: ""
        }
      }

      Category.new(invalid_category_data[:category]).wont_be :valid?

      start_category_count = Category.count
      post categories_path, params: invalid_category_data

      must_respond_with :redirect
      must_redirect_to new_merchant_category_path(@merchant.id)

      Category.count.must_equal start_category_count
    end
  end
end
