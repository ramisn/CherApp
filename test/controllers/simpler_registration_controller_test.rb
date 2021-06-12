# frozen_string_literal: true

require 'test_helper'

class SimplerRegistrationControllerTest < ActionDispatch::IntegrationTest
  test 'coborrower is redirected to onbording after sign up' do
    post simpler_registration_path, params: { user: { email: 'co_borrower_user@example.io', role: :co_borrower } }

    assert_redirected_to co_borrower_root_path
  end

  test 'agent is redirected to customer dashboard after sign up' do
    post simpler_registration_path, params: { user: { email: 'co_borrower_user@example.io', role: :agent } }

    assert_redirected_to customer_dashboard_path
  end
end
