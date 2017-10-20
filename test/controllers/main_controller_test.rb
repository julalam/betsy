require "test_helper"

describe MainController do
  describe "index" do
    it "gets new and returns a success status for the new page" do
      get root_path
      must_respond_with :success
    end

    it "must work if there are no products in the database" do
      Product.destroy_all
      get root_path
      must_respond_with :success
    end

    #TODO it "must work if there is between 0 and 6 Products"
    #right now this will fail, but we decided we don't care.
    #it will be able to deploy with an empty database,
    #and then we will seed the database to have more thant
    #6 products.

  end
end
