# frozen_string_literal: true

require 'test_helper'

module Admin
  class LoansControllerTest < ActionDispatch::IntegrationTest
    test 'it redirect no registered user to new session path' do
      get admin_co_borrower_loans_path(users(:co_borrower_user))

      assert_redirected_to new_user_session_path
      assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
    end

    test 'it redirects no admin user to roo path' do
      login_as users(:co_borrower_user)

      get admin_co_borrower_loans_path(users(:co_borrower_user))

      assert_redirected_to root_path
      assert_equal 'You cannot access this section.', flash[:alert]
    end

    test 'it success accessing to coborrower loans' do
      login_as users(:admin_user)

      get admin_co_borrower_loans_path(users(:co_borrower_user))

      assert_response :success
    end

    test 'it success displaying a loan' do
      WebStub.stub_redis_property
      co_borrower = users(:co_borrower_user)
      login_as users(:admin_user)
      loan = loans(:co_borrower_loan)

      get edit_admin_co_borrower_loan_path(co_borrower, loan)

      assert_response :success
    end

    test 'it success updating a loan' do
      co_borrower = users(:co_borrower_user)
      login_as users(:admin_user)
      loan = loans(:co_borrower_loan)

      patch admin_co_borrower_loan_path(co_borrower, loan), params: { loan: { status: :finished } }

      assert_redirected_to admin_co_borrower_loans_path(co_borrower)
      assert_equal 'Loan sucessfully updated', flash[:notice]
    end

    test 'it enqueued a email when loan is marked as finished' do
      co_borrower = users(:co_borrower_user)
      login_as users(:admin_user)
      loan = loans(:co_borrower_loan)

      patch admin_co_borrower_loan_path(co_borrower, loan), params: { loan: { status: :finished } }

      assert_enqueued_emails 1
    end
  end
end
