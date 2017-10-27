require "test_helper"

describe Order do
  describe "relations" do
    before do
      @order = orders(:one)
      # @order = Order.first
    end
    it "has many products" do
      @order.must_respond_to :products
      @order.products.each do |product|
         product.must_be_kind_of Product
       end
    end

    it "has many order_items" do
      @order.must_respond_to :order_items
      @order.order_items.each do |order_item|
        order_item.must_be_kind_of OrderItem
      end
    end

    # it "has many merchants through products" do
    #   @order.must_respond_to :merchants
    #   @order.merchants.each do |merchat|
    #     order_item.must_be_kind_of Merchant
    #   end
    #
    # end
  end

  describe "validations" do
    it "must be invalid" do
      order = Order.new
      result = order.valid?
      result.must_equal false
    end

    it 'must be valid' do
      order = Order.new
      order.status = 'pending'
      order.customer_name = 'Sue'
      order.customer_email = 'Sue@gmail.com'
      order.customer_address = '123 internet street'
      order.cc_number = '123123123'
      order.cc_expiration = '2020-10-01'
      order.cc_ccv = '980'
      order.zip_code = '98101'
      result = order.valid?
      result.must_equal true
    end
  end
end
