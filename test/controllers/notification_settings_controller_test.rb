# frozen_string_literal: true

require 'test_helper'

class NotificationSettingsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect no logged user' do
    get edit_notification_settings_path(0)

    assert_redirected_to new_user_session_path
  end

  test 'it success accessing to edit' do
    user = users(:co_borrower_user)
    login_as user

    get edit_notification_settings_path(user.id)

    assert_response :success
  end

  test 'it success updating settings' do
    user = users(:co_borrower_user)
    login_as user

    put notification_settings_path(user.id), params: { notification_settings: { friend_request_email: false } }

    assert_redirected_to co_borrower_dashboard_path
    assert_equal 'Notification settings successfully updated', flash[:notice]
  end
end
