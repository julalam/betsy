require "test_helper"

describe MerchantsController do

  describe "Wrong logged in users" do
    describe "show" do
      it "redirects to root path when a merchant tries to access another merchant's show page" do
        different_merchant = merchants(:eva)
        wrong_merchant = merchants(:emma)
        login(wrong_merchant)
        get merchant_path(different_merchant)
        must_redirect_to root_path
        flash[:message].must_equal "Failure: You cannot access account pages for other users"
        flash[:status].must_equal :failure
      end
    end
  end

  describe "Correct logged in user" do
    describe "show" do
      it "succeeds for a valid merchant ID from the correctly logged in user" do
        merchant = merchants(:eva)
        login(merchant)
        get merchant_path(merchant)
        must_respond_with :success
      end

      it "renders 404 not_found for a bogus product ID" do
        merchant = merchants(:eva)
        login(merchant)
        bogus_merchant_id = Merchant.last.id + 1
        get merchant_path(bogus_merchant_id)
        must_respond_with :not_found
      end
    end
  end

describe "Guest" do
  describe "show" do
    it "cannot access a merchant's show page" do
      #this merchant is not logged in (i.e. testing as a guest)
      merchant = merchants(:eva)
      get merchant_path(merchant.id)
      must_redirect_to root_path
      flash[:message].must_equal "You must be logged in to do that"
      flash[:status].must_equal :failure
    end


  end
end

  describe "auth_callback" do
    describe "login" do
      it "logs in an existing merchant and redirects to the root path" do
        start_count = Merchant.count

        merchant = merchants(:eva)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))

        get auth_callback_path(:github)

        flash[:status].must_equal :success
        flash[:message].must_equal "Logged in successfully as existing merchant #{merchant.username}"

        must_respond_with :redirect
        must_redirect_to root_path
        session[:merchant_id].must_equal merchant.id
        Merchant.count.must_equal start_count
      end

      it "creates an account for a new user and redirects to the root path" do
        start_count = Merchant.count

        merchant = Merchant.new(provider: "github", uid: 456, username: "new_merchant", email: "new@mail.com")

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path(:github)

        must_respond_with :redirect
        must_redirect_to root_path
        flash[:status].must_equal :success
        flash[:message].must_equal "Logged in successfully as new merchant #{merchant.username}"

        session[:merchant_id].must_equal Merchant.last.id
        Merchant.count.must_equal start_count + 1

      end

      it "tells the merchant that they're already logged in if that is true" do
        start_count = Merchant.count

        merchant = merchants(:eva)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path(:github)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path(:github)

        flash[:status].must_equal :failure
        flash[:message].must_equal "You're already logged in"

        must_respond_with :redirect
        must_redirect_to root_path
        Merchant.count.must_equal start_count

      end

      it "redirects to the root path if given invalid user data" do
        start_count = Merchant.count

        merchant = Merchant.new(username: "new_merchant", email: "new@mail.com")

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path(:github)

        flash[:status].must_equal :failure
        flash[:message].must_equal "Could not log in"

        must_respond_with :redirect
        must_redirect_to root_path
        session[:merchant_id].must_equal nil
        Merchant.count.must_equal start_count
      end
    end
  end

  describe "logout" do
    it "logs out merchant and redirects to the root path" do
      merchant = merchants(:eva)

      login(merchant)
      get logout_path

      flash[:status].must_equal :success
      flash[:message].must_equal "Successfully logged out"

      must_respond_with :redirect
      must_redirect_to root_path
      session[:merchant_id].must_equal nil
    end
  end
end
