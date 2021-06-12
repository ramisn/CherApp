# frozen_string_literal: true

require 'test_helper'

module CoBorrower
  class RentalsControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects user with no sesssion to new user session path' do
      get new_co_borrower_rental_path

      assert_redirected_to new_user_session_path
    end

    test 'it redirects to root path no coborrower user' do
      login_as users(:agent_user)

      get new_co_borrower_rental_path

      assert_redirected_to root_path
      assert_equal 'You cannot access this section.', flash[:alert]
    end

    test 'it success accessing to new rental' do
      login_as users(:co_borrower_user)

      get new_co_borrower_rental_path

      assert_response :success
    end

    test 'it success registering a rental' do
      login_as users(:co_borrower_user)

      post co_borrower_rentals_path, params: { rental: { monthly_rent: 1000,
                                                         bedrooms: 1,
                                                         address: '123 Main street, Santa Monica',
                                                         state: 'CA',
                                                         bathrooms: 2,
                                                         lease_duration: '1_month',
                                                         listed_by_type: 'owner',
                                                         phone_number: '1234567890' } }

      assert_enqueued_emails 2
      assert_redirected_to co_borrower_dashboard_path
      assert_equal 'House successfully registered', flash[:notice]
    end

    test 'it rendes new rental form when missing data' do
      login_as users(:co_borrower_user)

      post co_borrower_rentals_path, params: { rental: { monthly_rent: 1000,
                                                         bedrooms: 1,
                                                         state: 'CA',
                                                         bathrooms: 2,
                                                         phone_number: '1234567890' } }

      assert_template :new
      assert_equal 'Error registering house', flash[:alert]
    end
  end
end
