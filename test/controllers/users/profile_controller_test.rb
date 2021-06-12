# frozen_string_literal: true

require 'test_helper'

class Users::ProfileControllerTest < ActionDispatch::IntegrationTest
  test 'it response succes to edit request from user with no role' do
    user = users(:user_without_role)
    sign_in user

    get edit_profile_path(user)

    assert_response :success
  end

  test 'it response success on update user without role profile' do
    WebStub.stub_sendgrid_single_send
    WebStub.stub_sendgrid_contacts_search
    user = users(:user_without_role)
    sign_in user

    patch profile_path(user), params: { user: { role: :agent } }

    assert_redirected_to customer_dashboard_path
    assert_enqueued_emails 2
  end

  test 'it redirects agents to customer dashboard' do
    WebStub.stub_sendgrid_single_send
    WebStub.stub_sendgrid_contacts_search
    user = users(:user_without_role)
    sign_in(user)

    patch profile_path(user), params: { user: { role: :agent } }

    assert_redirected_to customer_dashboard_path
  end

  test 'it redirects co-owners to dashboard path when updating role' do
    WebStub.stub_sendgrid_single_send
    WebStub.stub_sendgrid_contacts_search

    user = users(:user_without_role)
    sign_in user

    patch profile_path(user), params: { user: { role: :co_borrower } }

    assert_redirected_to co_borrower_root_path
  end

  test 'it renders edit template when trying to update invalid role' do
    user = users(:user_without_role)
    sign_in user

    patch profile_path(user), params: { user: { role: :invalid } }

    assert_template :edit
  end
end
