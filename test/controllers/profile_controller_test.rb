# frozen_string_literal: true

require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects to customer dashboard when customer updates info' do
    user = users(:agent_user)

    login_as user

    put profile_path(user), params: { user: { description: 'new description' } }

    assert_redirected_to customer_dashboard_path
    assert user.reload.description, 'new description'
  end

  test 'it redirects to customer dashboard when updating number license' do
    user = users(:agent_user)

    login_as user

    put profile_path(user), params: { user: { number_license: '12345678' } }

    assert_redirected_to customer_dashboard_path
    assert_enqueued_emails 1
  end

  test 'it success when requesting update in json' do
    user = users(:agent_user)
    login_as user

    put profile_path(user), params: { user: { first_name: 'Mike' }, format: :json }

    assert_response :success
    assert_enqueued_emails 0
  end

  test 'it notify when agent completed its profile with number license' do
    WebStub.stub_sendgrid_contacts_search
    WebStub.stub_sendgrid_single_send
    user = users(:user_without_role)
    login_as user

    put profile_path(user), params: { user: { first_name: 'Mike', role: :agent, number_license: '12345678' } }

    assert_redirected_to customer_dashboard_path
    assert_enqueued_emails 3
  end

  test 'it notify cher team and agents when user sets city to buy in' do
    user = users(:co_borrower_user_3)
    login_as user

    put profile_path(user), params: { user: { city: 'Santa Monica' } }

    assert_enqueued_emails 2
  end
end
