# frozen_string_literal: true

require 'test_helper'

module Admin
  class InquiriesControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects no logged users to new session path' do
      get admin_inquiries_path

      assert_redirected_to new_user_session_path
    end

    test 'it redirect no admin users to root path' do
      login_as users(:agent_user)

      get admin_inquiries_path

      assert_redirected_to root_path
    end

    test 'it success when admin success to index' do
      login_as users(:admin_user)

      get admin_inquiries_path

      assert_response :success
    end

    test 'it success when admin access to edit' do
      user_inquiry = users(:agent_user)
      login_as users(:admin_user)

      get edit_admin_inquiry_path(user_inquiry)

      assert_response :success
    end

    test 'it success when admin update users inquiry data' do
      WebStub.stub_sendgrid_single_send
      user_inquiry = users(:agent_user)
      login_as users(:admin_user)

      assert_emails 1 do
        put admin_inquiry_path(user_inquiry), params: { user: { background_check_status: :approved } }
      end

      assert_redirected_to admin_inquiries_path
      assert "User's fund successfuly updated", flash[:notice]
    end
  end
end
