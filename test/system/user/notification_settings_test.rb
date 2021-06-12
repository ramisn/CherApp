# frozen_string_literal: true

require 'application_system_test_case'

class NotificationSettingsTest < ApplicationSystemTestCase
  def setup
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stup_ghost_blog_post
  end

  test 'user can access to notification settings' do
    user = users(:co_borrower_user)
    login_as user
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'

    find('.chat-button').click
    click_link 'Notifications'
    click_link 'Notification settings'

    assert_content 'Notification Settings'
  end

  test 'user can update its notification settings' do
    user = users(:co_borrower_user)
    login_as user
    visit co_borrower_dashboard_path

    click_link 'Notifications'
    click_link 'Notification settings'
    check 'notification_settings[preferences[flagged_home_email]]', allow_label_click: true
    click_button 'Save'

    assert_content 'Notification settings successfully updated'
  end
end
