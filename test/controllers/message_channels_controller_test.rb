# frozen_string_literal: true

require 'test_helper'

class MessageChannelsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect to new user session when user not logged' do
    channel = message_channels(:borrowers_channel)

    get message_channel_path(channel.id)

    assert_redirected_to new_user_session_path
  end

  test 'it success when searching by user id' do
    login_as users(:co_borrower_user)
    channel = message_channels(:borrowers_channel)

    get message_channel_path(channel.sid)

    assert_response :success
  end

  test 'it success by searching by id' do
    borrower = users(:co_borrower_user_2)
    login_as users(:co_borrower_user)
    channel = message_channels(:borrowers_channel)

    get message_channel_path(channel.sid), params: { users_id: borrower.id }

    assert_response :success
  end

  test 'it success creating a channel' do
    borrower = users(:user_without_responses)
    login_as users(:co_borrower_user)

    post message_channels_path, params: { channel: { sid: 'CH90a65f0fc0a04191901b7f71cd6b53c3',
                                                     purpose: 'conversation' },
                                          user_id: borrower.id }

    assert_response :success
  end

  test 'it success updating channel' do
    login_as users(:co_borrower_user)
    channel = message_channels(:borrowers_channel)

    put message_channel_path(channel.sid), params: { channel: { status: 'closed' } }

    assert_response :success
  end
end
