# frozen_string_literal: true

require 'test_helper'

module Admin
  class RentalsControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects user with no sesssion to new user session path' do
      get admin_rentals_path

      assert_redirected_to new_user_session_path
    end

    test 'it redirect no admin user to root path' do
      login_as users(:co_borrower_user)
      get admin_rentals_path

      assert_redirected_to root_path
      assert_equal 'You cannot access this section.', flash[:alert]
    end

    test 'it success when admin access to index' do
      login_as users(:admin_user)

      get admin_rentals_path

      assert_response :success
    end

    test 'it success accesing to rental show' do
      login_as users(:admin_user)
      rental = rentals(:co_borrower_rental)

      get admin_rental_path(rental)

      assert_response :success
    end

    test 'it success updating rental' do
      login_as users(:admin_user)
      rental = rentals(:co_borrower_rental)

      patch admin_rental_path(rental), params: { rental: { status: :approved } }

      assert_redirected_to admin_rentals_path
      assert_equal 'House successfully updated', flash[:notice]
    end
  end
end
