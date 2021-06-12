# frozen_string_literal: true

require 'application_system_test_case'

class NotificationTest < ApplicationSystemTestCase
  def setup
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stup_ghost_blog_post
  end

  test 'user can see its notification' do
    user = users(:user_without_responses)
    login_as user
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'

    find('.chat-button').click
    click_link 'Notifications'

    assert_content 'Notifications'
    assert_equal all('.in-app-notification').count, 1
    assert_content 'NEW'
  end

  test 'user can delete notification' do
    user = users(:user_without_responses)
    notification = user.received_notifications.active.first

    login_as user
    visit notifications_path

    assert_equal all('.in-app-notification').count, 1
    find("#notification-#{notification.id}").click

    assert_equal all('.in-app-notification').count, 0
  end
end
