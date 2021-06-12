# frozen_string_literal: true

require 'test_helper'

module CoBorrower
  class HousesControllerTest < ActionDispatch::IntegrationTest
    test 'it redirect no logged user' do
      get new_co_borrower_house_path

      assert_redirected_to new_user_session_path
    end

    test 'it success requesting for a new sale' do
      login_as users(:co_borrower_user)
      get new_co_borrower_house_path

      assert_response :success
    end

    test 'it success requesting for house registration' do
      login_as users(:co_borrower_user)

      post co_borrower_houses_path, params: { house: { address: '123 Main Street', state: 'CA',
                                                       county: 'Alameda', price: 2_000_000,
                                                       ownership_percentage: 100,
                                                       home_type: :condo, beds: 2,
                                                       full_baths: 2, half_baths: 0,
                                                       interior_area: 100, lot_size: 100,
                                                       year_build: 1998, hoa_dues: 0,
                                                       basement_area: 100, garage_area: 10,
                                                       description: 'A wonderful place to live',
                                                       details: '', date_for_open_house: nil,
                                                       start_hour_for_open_house: nil,
                                                       end_hour_for_open_house: nil,
                                                       website: nil, phone_contact: '1232885476',
                                                       email_contact: 'user@email.com',
                                                       status: :pending, accept_terms: true } }

      assert_redirected_to co_borrower_dashboard_path
      assert_equal 'House successfully registered', flash[:notice]
      assert_enqueued_emails 1
    end

    test 'it render form when reequesting for inavelid house' do
      login_as users(:co_borrower_user)

      post co_borrower_houses_path, params: { house: { address: '123 Main Street', state: 'CA',
                                                       county: 'Alameda', price: 2_000_000,
                                                       home_type: :condo, beds: 2,
                                                       full_baths: 2, half_baths: 0,
                                                       interior_area: 100, lot_size: 100,
                                                       year_build: 1998, hoa_dues: 0,
                                                       basement_area: 100, garage_area: 10,
                                                       description: 'A wonderful place to live',
                                                       details: '', date_for_open_house: nil,
                                                       start_hour_for_open_house: nil,
                                                       end_hour_for_open_house: nil,
                                                       website: nil, phone_contact: '1232885476',
                                                       email_contact: 'user@email.com',
                                                       status: :pending, accept_terms: false } }

      assert_template :new
      assert_equal 'Error registering house', flash[:alert]
    end

    test 'it succeeds saving house as draft' do
      login_as users(:co_borrower_user)

      post co_borrower_houses_path, params: { house: { address: '123 Main Street', state: 'CA',
                                                       county: 'Alameda', price: 2_000_000,
                                                       ownership_percentage: 100,
                                                       home_type: :condo, beds: 2,
                                                       full_baths: 2, half_baths: 0,
                                                       email_contact: 'user@email.com' },
                                              commit: 'Save Draft' }

      assert_redirected_to co_borrower_dashboard_path
      assert_equal 'Draft saved correctly', flash[:notice]
    end

    test 'it succeeds fetching last saved draft' do
      House.create(owner: users(:co_borrower_user), address: '123 Main Street',
                   state: 'CA', county: 'Alameda', price: 200_000,
                   email_contact: 'user@email.com', draft: true)
      login_as users(:co_borrower_user)
      get new_co_borrower_house_path

      assert_response :success
      assert_equal 'Draft opened correctly', flash[:notice]
    end
  end
end
