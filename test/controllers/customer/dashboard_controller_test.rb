# frozen_string_literal: true

require 'test_helper'

class Customer::DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects to new session when no logged user access to section' do
    get customer_dashboard_path

    assert_redirected_to new_user_session_path
  end

  test 'it redirects to root path when no customer access to section' do
    login_as users(:co_borrower_user)

    get customer_dashboard_path

    assert_redirected_to root_path
  end

  test 'it success when customer access to section' do
    login_as users(:agent_user)

    get customer_dashboard_path

    assert_response :success
  end

  test 'it redirect to profile edit when estate agent access with referal agrement not accepted' do
    agent = users(:agent_user)
    agent.update(accept_referral_agreement: false, professional_role: :estate_agent)
    login_as agent

    get customer_dashboard_path

    assert_redirected_to edit_profile_path(agent)
    assert_equal 'You need to accept the referral agreement', flash[:alert]
  end

  test 'it success when no estate agent access with referal agrement not accepted' do
    agent = users(:agent_user)
    agent.update(accept_referral_agreement: false, professional_role: :loan_officer)
    login_as agent

    get customer_dashboard_path

    assert_response :success
  end
end
