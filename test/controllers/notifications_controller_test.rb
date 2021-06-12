# frozen_string_literal: true

require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test 'it success updating notification' do
    login_as users(:user_without_responses)
    notification = notifications(:santa_monica_flagged_property_notification)

    put notification_path(notification), params: { notification: { status: :readed }, format: :json }

    assert_response :success
  end

  test 'it success listing users notifications' do
    login_as users(:user_without_responses)

    get notifications_path

    assert_response :success
  end

  test 'it success when deleting notification' do
    login_as users(:user_without_responses)
    notification = notifications(:santa_monica_flagged_property_notification)

    delete notification_path(notification)

    assert_response :redirect
    assert_redirected_to notifications_path
  end
end
