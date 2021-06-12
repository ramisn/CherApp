# frozen_string_literal: true

require 'application_system_test_case'

class ConversationsTesr < ApplicationSystemTestCase
  setup do
    WebStub.stup_ghost_blog_post
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
  end

  test 'user can navigate to his/her conversations' do
    WebStub.stub_redis_properties
    login_as users(:co_borrower_user)

    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'

    find('a[href="/conversations"]').click

    assert_content 'Messages'
    assert_content 'Filtered by:'
  end

  test 'user can access to new message though messages list' do
    WebStub.stub_redis_properties
    login_as users(:co_borrower_user)

    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'

    find('a[href="/conversations"]').click
    find('a[href="/conversations/new"]').click

    assert_content 'New message'
  end

  test 'user can navigate to notifications through messages' do
    login_as users(:co_borrower_user)

    visit conversations_path
    click_link 'Notifications'

    assert_content 'Notifications'
  end

  test 'user can navigate to look around through messages' do
    WebStub.stub_redis_properties
    login_as users(:co_borrower_user)

    visit conversations_path
    click_link 'Search Homes'

    assert_content 'Featured Homes', wait: 5
  end

  test 'user can start a group from the property detail page' do
    WebStub.stub_properties_request
    WebStub.stub_property_places
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein
    WebStub.stub_twilio_sms
    WebStub.stub_bitly

    login_as users(:co_borrower_user)

    visit property_path('13322')

    click_link 'Start chat'

    assert_content 'Create group'
  end
end
