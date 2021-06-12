# frozen_string_literal: true

require 'test_helper'

class Customer::CheckoutControllerTest < ActionDispatch::IntegrationTest
  test 'a non register user can see the checkout page' do
    login_as users(:co_borrower_user)

    get customer_checkout_index_path

    assert_response :success
  end

  test 'it success when accessing with a plan' do
    login_as users(:agent_user)

    get customer_checkout_index_path

    assert_response :success
  end

  test 'it renders payment template when user already has a plan' do
    agent = users(:agent_user)
    agent.update(plan_type: 'premium', end_of_clique: Date.today + 1.week)
    login_as users(:agent_user)

    get customer_checkout_index_path

    assert_template :pricing
    assert_equal "You're already part of Cher Clique. Please wait untill #{Date.today + 1.week}", flash[:notice]
  end
end
