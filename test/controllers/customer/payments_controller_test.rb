# frozen_String_literal: true

require 'test_helper'

module Customer
  class PaymentsControllerTest < ActionDispatch::IntegrationTest
    test 'it succeeds showing if not logged in' do
      WebStub.stub_stripe_payment_intent
      get customer_payment_path('123abc')

      assert_response :success
    end

    test 'it success posting a payment and creating a user' do
      WebStub.stub_stripe_customer_list
      WebStub.stub_stripe_customer_creation
      WebStub.stub_stripe_payment_method_creation
      WebStub.stub_stripe_customer_payment_attach
      WebStub.stub_stripe_payment_method_creation
      WebStub.stub_stripe_subscription_creation
      WebStub.stub_stripe_invoice
      WebStub.stub_stripe_payment_intent
      WebStub.stub_twilio_chat_response
      WebStub.stub_twilio_chat_response

      assert_difference 'User.count', 1 do
        post customer_payments_path, params: { payment_method_id: '123abc', email: 'gerald@amezcua.com', first_name: 'Gerald', last_name: 'Amezcua' }
      end

      assert_response :success
    end

    test 'it success when posting a payment' do
      WebStub.stub_stripe_customer_list
      WebStub.stub_stripe_customer_creation
      WebStub.stub_stripe_payment_method_creation
      WebStub.stub_stripe_customer_payment_attach
      WebStub.stub_stripe_payment_method_creation
      WebStub.stub_stripe_subscription_creation
      WebStub.stub_stripe_invoice
      WebStub.stub_stripe_payment_intent
      WebStub.stub_twilio_chat_response
      WebStub.stub_twilio_chat_response
      login_as users(:co_borrower_user)

      post customer_payments_path, params: { payment_method_id: '123abc' }

      assert_response :success
    end
  end
end
