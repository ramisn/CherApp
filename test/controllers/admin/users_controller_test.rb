# frozen_string_literal: true

require 'test_helper'

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects no logged users' do
      put admin_user_path(users(:co_borrower_user)), params: { user: { ssn: '213wdas' } }

      assert_redirected_to new_user_session_path
      assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
    end

    test 'it redirects no admin users' do
      login_as users(:co_borrower_user)
      put admin_user_path(users(:co_borrower_user)), params: { user: { ssn: '213wdas' } }

      assert_redirected_to root_path
      assert_equal 'You cannot access this section.', flash[:alert]
    end
  end
end
