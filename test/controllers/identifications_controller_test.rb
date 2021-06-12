# frozen_string_literal: true

require 'test_helper'

class IdentificationsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect coborrower to dashboar if he/she is already validated' do
    co_borrower_user = users(:co_borrower_user)
    co_borrower_user.update(verification_type: 'passport')
    login_as co_borrower_user

    get new_identification_path

    assert_redirected_to co_borrower_dashboard_path
  end

  test 'it redirect agent to dashboard if he/she is already validated' do
    agent_user = users(:agent_user)
    agent_user.update(verification_type: 'passport')
    login_as agent_user

    get new_identification_path

    assert_redirected_to customer_dashboard_path
  end

  test 'it redirect user to dashboard when update the verification type' do
    agent_user = users(:agent_user)
    login_as agent_user

    post identification_path, params: { data: { result: { type: 'passport' } } }

    assert_redirected_to customer_dashboard_path
  end
end
