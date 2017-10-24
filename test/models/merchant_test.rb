require "test_helper"

describe Merchant do

  # describe "relations" do
  #
  # end
  #
  # decribe "validations" do
  #
  # end


  describe "custom methods" do

    describe "order_items_quantity" do
      # eva has two order items each with a quantity of 2 and a price of 2 and 3, respectively.
      it "returns total quantity of a merchant's order items" do
        merchants(:eva).order_items_quantity.must_equal 4
      end

      it "returns 0 for a merchant with no order items" do
        merchants(:no_orders).order_items_quantity.must_equal 0
      end


    end

    describe "order_items_total" do
      # eva has two order items each with a quantity of 2 and a price of 2 and 3, respectively.
      it "returns sum of a merchant's order items" do
        merchants(:eva).order_items_total.must_equal 10
      end

      it "returns 0 for a merchant with no order items" do
        merchants(:no_orders).order_items_quantity.must_equal 0
      end
    end



  end



end
