# frozen_string_literal: true

require 'test_helper'

class CoBorrower::InquiriesControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect user to login when no logged user try to access new inquiry section' do
    get new_co_borrower_inquiry_path

    assert_redirected_to new_user_session_path
  end

  test 'it redirect to customer dashboard when a customer try to access new inquire section' do
    login_as users(:agent_user)

    get new_co_borrower_inquiry_path

    assert_redirected_to root_path
  end

  test 'it success when a coborrower access to new inquiry section' do
    login_as users(:co_borrower_user)

    get new_co_borrower_inquiry_path

    assert_response :success
  end

  test 'it redirects to dashboard when co borrower request is success' do
    login_as users(:co_borrower_user)

    post co_borrower_inquiries_path, params: { inquiry: { firstname: 'Miguel', lastname: 'Urbina', date_of_birth: '01/13/1997' } }

    assert_redirected_to co_borrower_dashboard_path
    assert_equal 'Background check now is under review', flash[:notice]
  end

  test 'it redirects to dashboard when user with background check pending tries to request again' do
    co_borrower = users(:co_borrower_user)
    co_borrower.update(background_check_status: :pending)
    login_as co_borrower

    post co_borrower_inquiries_path, params: { inquiry: { firstname: 'Miguel' } }

    assert_redirected_to co_borrower_dashboard_path
    assert_equal 'You already requested an inquiry, which is under review', flash[:alert]
  end

  test 'it redirects to dashboard when user with background check approved tries to request again' do
    co_borrower = users(:co_borrower_user)
    co_borrower.update(background_check_status: :approved)
    login_as co_borrower

    post co_borrower_inquiries_path, params: { inquiry: { firstname: 'Miguel' } }

    assert_redirected_to co_borrower_dashboard_path
    assert_equal 'Your background check was already approved', flash[:alert]
  end
end
