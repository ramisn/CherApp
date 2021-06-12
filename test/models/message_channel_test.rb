# frozen_string_literal: true

# == Schema Information
#
# Table name: message_channels
#
#  id           :bigint           not null, primary key
#  sid          :string
#  participants :string           default("{}"), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :integer          default("0")
#  purpose      :string           default("conversation")
#  image_url    :string
#

require 'test_helper'

class MessageChannelTest < ActiveSupport::TestCase
  test 'it is not valid without sid' do
    message_channel = MessageChannel.new(participants: ['miguel@cher.app', 'hector@cher.app'])

    refute message_channel.valid?
    assert message_channel.errors[:sid].any?
  end

  test 'it is not valid without participants' do
    message_channel = MessageChannel.new(sid: '123asd')

    refute message_channel.valid?
    assert message_channel.errors[:participants].any?
  end

  test 'it is valid with all attributes' do
    message_channel = MessageChannel.new(sid: '123asd', participants: ['miguel@cher.app', 'hector@cjer.app'], image_url: 'cherapp-ownership-coborrowing-ico-user.svg')

    assert message_channel.valid?
  end

  test 'it is valid without image' do
    message_channel = MessageChannel.new(sid: '123asd', participants: ['miguel@cher.app', 'hector@cjer.app'])

    assert message_channel.valid?
  end

  test 'it creates a notification when creating a new channel' do
    requester = users(:co_borrower_user)
    requestee = users(:co_borrower_user_2)

    assert_difference 'Notification.count', 1 do
      MessageChannel.create!(sid: '123asd', participants: [requester.email, requestee.email])
    end
  end

  test 'it does not create a notification if user do not accept conversation notifications' do
    requester = users(:co_borrower_user)
    requestee = users(:co_borrower_user_2)
    requestee.notification_settings.update!(preferences: { conversation_in_app: 0 })

    assert_difference 'Notification.count', 0 do
      MessageChannel.create!(sid: '123asd', participants: [requester.email, requestee.email])
    end
  end

  test 'it finds a channel by given participants' do
    channel = MessageChannel.find_by_participants('borrower@user.com', 'borrower2@user.com')

    assert channel
  end

  test 'it creates a new channel by given participants' do
    WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
           .to_return(status: 200, body: { sid: 'CH1234567890' }.to_json)
    first_participants = users(:discarded_user)
    second_participants = users(:co_borrower_user_2)

    channel = MessageChannel.create_channel(first_participants.email, second_participants.email)

    assert channel
    assert_equal 'CH1234567890', channel.sid
    assert_equal [first_participants.email, second_participants.email], channel.participants
  end

  test 'it os not valid with a purpose out of group, conversation or professional_contact' do
    message_channel = MessageChannel.new(sid: '123asd', participants: ['miguel@cher.app', 'hector@cjer.app'], purpose: 'invalid')

    refute message_channel.valid?
    assert message_channel.errors[:purpose].any?
  end
end
