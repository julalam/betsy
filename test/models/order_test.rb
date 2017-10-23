require "test_helper"

describe Order do
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

  it 'must be invalid' do
    order = Order.new
    result = order.valid?
    result.must_equal false
  end
end
