# frozen_String_literal: true

require 'test_helper'

module Customer
  class MessageCreditsControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects no logged user' do
      post customer_message_credits_path

      assert_redirected_to new_user_session_path
      assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
    end

    test 'it redirects no customer logged user' do
      login_as users(:co_borrower_user)

      post customer_message_credits_path

      assert_redirected_to root_path
      assert_equal 'You cannot access this section.', flash[:alert]
    end

    test 'it fails if customer is not clique' do
      login_as users(:agent_user)

      post customer_message_credits_path

      assert_redirected_to customer_dashboard_path
      assert_equal 'You need to be a Clique Premium Agent to buy credits', flash[:alert]
    end

    test 'it fails if customer not available' do
      WebStub.stub_stripe_no_customer
      login_as users(:clique_agent)

      post customer_message_credits_path

      assert_redirected_to customer_dashboard_path
      assert_equal 'Customer not available', flash[:alert]
    end

    test 'it succeeds if customer has clique and customer' do
      WebStub.stub_stripe_customer
      WebStub.stub_stripe_charge
      login_as users(:clique_agent)

      post customer_message_credits_path

      assert_redirected_to customer_dashboard_path
      assert_equal 'Credits paid successfully', flash[:notice]
      assert_equal 8, users(:clique_agent).message_credits
    end
  end
end
