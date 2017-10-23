require "test_helper"

describe MerchantsController do

 describe "CRUD methods" do
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

  describe "show" do
    it "succeeds for an valid merchant ID" do
      get merchant_path(Merchant.first)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus product ID" do
      bogus_merchant_id = Merchant.last.id + 1
      get merchant_path(bogus_merchant_id)
      must_respond_with :not_found
    end
  end

  describe "index" do
    it "succeeds when there are merchants" do
      get merchants_path
      must_respond_with :success
    end

    it "succeeds when there are no merchantss" do
      Product.destroy_all
      get merchants_path
      must_respond_with :success
    end
  end
end


  describe "login" do
    it "logs in an existing merchant and redirects to the root path" do
      start_count = Merchant.count

      merchant = merchants(:eva)

      login(merchant)

      must_respond_with :redirect
      must_redirect_to root_path
      session[:merchant_id].must_equal merchant.id
      Merchant.count.must_equal start_count

    end

    it "creates an account for a new user and redirects to the root path" do
      start_count = Merchant.count

      merchant = Merchant.new(provider: "github", uid: 456, username: "new_merchant", email: "new@mail.com")

      login(merchant)

      must_respond_with :redirect
      must_redirect_to root_path
      session[:merchant_id].must_equal Merchant.last.id
      Merchant.count.must_equal start_count + 1

    end

    it "redirects to the root path if given invalid user data" do
      start_count = Merchant.count

      merchant = Merchant.new(username: "new_merchant", email: "new@mail.com")

      login(merchant)

      must_respond_with :redirect
      must_redirect_to root_path
      session[:merchant_id].must_equal nil
      Merchant.count.must_equal start_count
    end
  end

  describe "logout" do
    it "logs out merchant and redirects to the root path" do
      merchant = merchants(:eva)

      login(merchant)
      get logout_path

      must_respond_with :redirect
      must_redirect_to root_path
      session[:merchant_id].must_equal nil
    end
  end
end
