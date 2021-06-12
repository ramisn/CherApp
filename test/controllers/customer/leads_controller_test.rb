# frozen_string_literal: true

require 'test_helper'

class Customer::LeadsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no logged user' do
    get customer_leads_path

    assert_redirected_to new_user_session_path
    assert 'Log in', flash[:alert]
  end

  test 'it redirects no customer user' do
    login_as users(:co_borrower_user)
    get customer_leads_path

    assert 'You can not access this section', flash[:alert]
  end

  test 'it succcess getting user with clieque' do
    login_as users(:clique_agent)
    get customer_leads_path

    assert_response :success
  end

  test 'it redirects getting user without clieque' do
    login_as users(:agent_user)
    get customer_leads_path

    assert 'Join Clique Premium to access to our buyers', flash[:alert]
  end
end
