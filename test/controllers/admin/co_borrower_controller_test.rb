# frozen_string_literal: true

require 'test_helper'

module Admin
  class CoBorrowerControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects no logged user to new session path' do
      get admin_co_borrowers_path

      assert_redirected_to new_user_session_path
      assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
    end

    test 'it redirects no admin to root path' do
      login_as users(:co_borrower_user)
      get admin_co_borrowers_path

      assert_redirected_to root_path
      assert_equal 'You cannot access this section.', flash[:alert]
    end

    test 'it success listing all users' do
      login_as users(:admin_user)
      get admin_co_borrowers_path

      assert_response :success
    end
  end
end
