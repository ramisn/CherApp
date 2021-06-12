# frozen_string_literal: true

# == Schema Information
#
# Table name: friend_requests
#
#  id           :bigint           not null, primary key
#  requester_id :bigint           not null
#  requestee_id :bigint           not null
#  status       :integer          default("0"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  test 'request is not valid with neither requester and requestee' do
    request = FriendRequest.new

    refute request.valid?
  end

  test 'request is not valid with no requestee' do
    requester = users(:co_borrower_user_2)

    request = FriendRequest.new(requester: requester)

    refute request.valid?
  end

  test 'request is not valid with no requester' do
    request = FriendRequest.new(requestee: users(:co_borrower_user))

    refute request.valid?
  end

  test 'request status is pending by default' do
    requester = users(:co_borrower_user_2)

    request = FriendRequest.new(requester: requester, requestee: users(:co_borrower_user))

    assert request.pending?
  end

  test 'request is valid with requester and requesteee' do
    requester = users(:co_borrower_user_2)

    request = FriendRequest.new(requester: requester, requestee: users(:co_borrower_user))

    assert request.valid?
  end

  test 'it create notification when creating friend request' do
    requester = users(:co_borrower_user_2)

    assert_difference 'Notification.count', 1 do
      FriendRequest.create(requester: requester, requestee: users(:co_borrower_user))
    end
  end

  test 'it does not create a notification is user does not accept in-app notifications' do
    requester = users(:co_borrower_user_2)
    requestee = users(:co_borrower_user)
    requestee.notification_settings.update!(preferences: { friend_request_in_app: 0 })

    assert_difference 'Notification.count', 0 do
      FriendRequest.create(requester: requester, requestee: requestee)
    end
  end
end
