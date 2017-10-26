require "test_helper"

describe CategoriesController do
  describe "correct logged in user" do
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

      it "succeeds when there are no categories" do
        Category.destroy_all
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

  describe "Wrong logged in users" do
    before do
      @different_merchant = merchants(:eva)
      @wrong_merchant = merchants(:emma)
      login(@wrong_merchant)
    end
    describe "new" do
      it "cannot access another merchant's categories new page" do
        #wrong_merchant is logged in and trying to create a new category as different_merchant (should trigger allowed_user method's flash messages)
        get new_merchant_category_path(@different_merchant.id)
        must_redirect_to root_path
        flash[:message].must_equal "Failure: You cannot access account pages for other users"
        flash[:status].must_equal :failure
      end
    end

    describe "index" do
      it "cannot access another merchant's categories index page" do
        # wrong user is logged in and trying to access a different merchant's index page
        get merchant_categories_path(@different_merchant.id)
        must_redirect_to root_path
        flash[:message].must_equal "Failure: You cannot access account pages for other users"
        flash[:status].must_equal :failure
      end
    end
  end


  describe "Guest users" do
    describe "new" do
      it "cannot access a merchant's categories new page" do
        #this merchant is not logged in (i.e. testing as a guest)
        merchant = merchants(:eva)
        get new_merchant_category_path(merchant.id)
        must_redirect_to root_path
        flash[:message].must_equal "You must be logged in to do that"
        flash[:status].must_equal :failure
      end
    end

    describe "index" do
      it "cannot access index page" do
        @merchant = merchants(:eva)
        get merchant_categories_path(@merchant.id)
        must_redirect_to root_path
        flash[:message].must_equal "You must be logged in to do that"
        flash[:status].must_equal :failure
      end
    end
  end


end
