# frozen_string_literal: true

require 'test_helper'

class Users::DashboardControllerTest < ActionDispatch::IntegrationTest
  test 'logged co borrower user can access to dashboard' do
    WebStub.stub_properties_request
    co_borrower_user = users(:co_borrower_user)

    sign_in co_borrower_user
    get co_borrower_dashboard_path

    assert_response :success
  end

  test 'logged co borrower user cannot access to customer dahsboard' do
    co_borrower_user = users(:co_borrower_user)

    sign_in co_borrower_user
    get customer_dashboard_path

    assert_response :redirect
  end

  test 'logged agent user cannot acces to co borrower dahsboard' do
    agent_user = users(:agent_user)

    sign_in agent_user
    get co_borrower_dashboard_path

    assert_response :redirect
  end

  test 'no logged user cannot access to any dashboard' do
    dashboards = [customer_dashboard_path, co_borrower_dashboard_path]

    dashboards.each do |path|
      get path
      assert_response :redirect
    end
  end
end
