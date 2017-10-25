require "test_helper"

describe OrdersController do
  describe "login tests" do
    before do
      @merchant = merchants(:eva)
      login(@merchant)
    end

    describe 'primary pages' do
      it "must be get index page" do
        get orders_path
        assert_response :success
      end

      describe 'show' do
        it 'must get show page' do
          get orders_path(orders(:one).id)
          assert_response :success
        end

        it 'must not find invalid show page' do
          get order_path(999999)
          must_respond_with :missing
        end

        describe 'nested show page' do
          it 'gets show page for merchant order' do
            get merchant_order_path(merchants(:eva).id, orders(:two).id)
            must_respond_with :success
          end

          it 'must not find invalid show page for merchant order' do
            get merchant_order_path(merchant_id: merchants(:no_orders).id, id: orders(:two).id)
            must_respond_with :bad_request
          end

        end
      end


      it 'must get edit page' do
        get edit_order_path(orders(:two).id)
        assert_response :success
      end

      it 'must not find an invalid edit page' do
        get edit_order_path(99999)
        must_respond_with :missing
      end

      it 'must get new order page' do
        get new_order_path
        assert_response :success
      end
    end

    describe 'Validations' do
      it 'adds a new valid order' do
        post orders_path, params: {
          order: {
            status: 'john',
            customer_name: 'creator 1',
            customer_email: 'john@gmail.com',
            customer_address: '123 5th ave',
            cc_number: '12312312312',
            cc_expiration: '2019-10-10',
            cc_ccv: '907',
            zip_code: '98101'
          }
        }
        must_respond_with :redirect
      end

      it 'adds an new invalid order' do
        post orders_path, params: {
          order: {
            status: 'john',
          }
        }
        must_respond_with :redirect
      end

      it "Updates an existing order" do
        order = Order.first
        order_params = {
          id: order.id,
          order: {
            status: 'pending',
            customer_name: 'creator 1',
            customer_email: 'john@gmail.com',
            customer_address: '123 5th ave',
            cc_number: '12312312312',
            cc_expiration: '2019-10-10',
            cc_ccv: '907',
            zip_code: '98101'
          }
        }

        patch order_path(order), params: order_params
        order = Order.first
        order.customer_name.must_equal 'john@gmail.com'
      end


    end
  end

end
