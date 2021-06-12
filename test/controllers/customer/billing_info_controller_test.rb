# frozen_string_literal: true

require 'test_helper'

class Customer::BillingInfoControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no logged user to new session path' do
    get edit_customer_billing_info_path(users(:agent_user))

    assert_redirected_to new_user_session_path
    assert flash[:alert], 'You can not access this section'
  end

  test 'it redirects no professionals to root path' do
    login_as users(:co_borrower_user)
    get edit_customer_billing_info_path(users(:agent_user))

    assert_redirected_to root_path

    assert flash[:alert], 'You can not access this section'
  end

  test 'it success accesinng to edit' do
    WebStub.stub_stripe_customer_list
    WebStub.stub_stripe_customer_creation
    WebStub.stub_stripe_customer_payment_methods
    login_as users(:agent_user)

    get edit_customer_billing_info_path(users(:agent_user))

    assert_response :success
  end

  test 'it success removing subscription' do
    WebStub.stub_stripe_subscription_removal
    login_as users(:agent_user)

    delete customer_billing_info_path(users(:agent_user)), params: { id: '123abc' }

    assert_redirected_to customer_dashboard_path
    assert_equal 'You unsubscribed from Clique Premium', flash[:notice]
  end

  test 'it sends a email after deleting subscription' do
    WebStub.stub_stripe_subscription_removal
    login_as users(:clique_agent)

    delete customer_billing_info_path(users(:clique_agent)), params: { id: '123abc' }

    assert_enqueued_jobs 1
  end
end
