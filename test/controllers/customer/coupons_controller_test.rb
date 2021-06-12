# frozen_string_literal: true

require 'test_helper'

module Customer
  class CouponsControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects no logged user' do
      get customer_coupon_path('123abc')

      assert_redirected_to new_user_session_path
    end

    test 'it redirects no customer users' do
      login_as users(:co_borrower_user)

      get customer_coupon_path('123abc')

      assert_redirected_to root_path
    end

    test 'it success getting a valid coupon' do
      login_as users(:agent_user)
      WebMock.stub_request(:get, %r{https://api.stripe.com/v1/coupons.*})
             .to_return(status: 200, body: {}.to_json)

      get customer_coupon_path('123abc'), params: { format: :json }

      assert_response :success
    end

    test 'it fails getting a valid coupon' do
      login_as users(:agent_user)
      WebMock.stub_request(:get, %r{https://api.stripe.com/v1/coupons.*})
             .to_return(status: 404, body: { error: { code: 'resource_missing' } }.to_json)

      get customer_coupon_path('123abc'), params: { format: :json }

      assert_response :not_found
    end
  end
end
