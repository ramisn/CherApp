# frozen_string_literal: true

require 'test_helper'

module Admin
  class HousesControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects no logged user to new session' do
      get admin_houses_path

      assert_redirected_to new_user_session_path
    end

    test 'it redirects no admin users to root path' do
      login_as users(:co_borrower_user)

      get admin_houses_path

      assert_redirected_to root_path
    end

    test 'it success accessing for houses' do
      login_as users(:admin_user)

      get admin_houses_path

      assert_response :success
    end

    test 'it success editing for a house' do
      house = houses(:co_borrower_house)
      login_as users(:admin_user)

      get edit_admin_house_path(house)

      assert_response :success
    end

    test 'it success updating a house' do
      house = houses(:co_borrower_house)
      login_as users(:admin_user)

      put admin_house_path(house), params: { house: { status: :approved } }
      house.reload

      assert_redirected_to admin_houses_path
      assert_equal 'House successfully updated', flash[:notice]
      assert house.approved?
    end
  end
end
