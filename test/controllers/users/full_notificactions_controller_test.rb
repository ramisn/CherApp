# frozen_string_literal: true

require 'test_helper'

module Users
  class FullNotificationsControllerTest < ActionDispatch::IntegrationTest
    test 'it success if signed in when notifying' do
      sign_in users(:co_borrower_user)
      user = users(:co_borrower_user_3)
      post full_notifications_path, params: { full_notification: { recipient: user.email, type: 'property', link: 'cher.app/properties/abc123' }, format: :json }

      assert_response :success
      assert_match 'Email sent', response.body
    end

    test 'it fails if not signed in' do
      user = users(:co_borrower_user_3)
      post full_notifications_path, params: { full_notification: { recipient: user.email, type: 'property', link: 'cher.app/properties/abc123' }, format: :json }

      assert_response 401
      assert_match 'You need to sign in or sign up before continuing.', response.body
    end
  end
end
