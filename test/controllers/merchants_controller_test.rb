require "test_helper"

describe MerchantsController do
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
