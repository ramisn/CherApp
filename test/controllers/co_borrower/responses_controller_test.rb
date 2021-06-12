# frozen_string_literal: true

require 'test_helper'

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect user with no session' do
    post co_borrower_responses_path

    assert_redirected_to new_user_session_path
  end

  test 'it redirect user to onbording' do
    live_factor = live_factors(:neat_person)
    login_as users(:co_borrower_user)

    post co_borrower_responses_path, params: { user: { responses_attributes: { "0": { live_factor_id: live_factor.id, response: 0 } } } }

    assert_redirected_to co_borrower_root_path
  end

  test 'it redirects user to personality test when success deleting responses' do
    user = users(:verified_user)
    login_as user

    delete co_borrower_response_path(user), params: { mathod: :delete }

    assert_redirected_to new_co_borrower_response_path
  end

  test 'it let no verified user to access to test section' do
    user = users(:co_borrower_user)
    login_as user

    get new_co_borrower_response_path

    assert_response :success
  end

  test 'it redirect user to personality test on thirth reset having more thang 6 months since last' do
    user = users(:verified_user)
    user.update(test_reset_period: Date.today + 6.months + 1.day, test_attempts: 2)
    login_as user

    delete co_borrower_response_path(user)

    assert_redirected_to new_co_borrower_response_path
    assert_equal Date.today, user.test_reset_period
    assert_equal 1, user.test_attempts
  end
end
