# frozen_string_literal: true

require 'test_helper'

class Admin::ProspectsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no logged user to new session path' do
    get new_admin_prospect_path

    assert_redirected_to new_user_session_path
    assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
  end

  test 'it redirects no admin user to landing page' do
    login_as users(:co_borrower_user)
    get new_admin_prospect_path

    assert_redirected_to root_path
    assert_equal 'You cannot access this section.', flash[:alert]
  end

  test 'it success creating a new prospect' do
    login_as users(:admin_user)

    post admin_prospect_path, params: { prospect: { email: 'new_user@cher.app' } }

    assert_redirected_to admin_contacts_path
    assert_equal 'Prospect successfully registered', flash[:notice]
  end
end
