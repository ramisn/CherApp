# frozen_string_literal: true

require 'test_helper'

class SendFriendRequestTrackerJobTest < ActiveJob::TestCase
  test 'job is enqueued after sent a friend request' do
    requester = users(:co_borrower_user_2)
    requestee = users(:co_borrower_user)
    requestee.notification_settings.update!(preferences: { friend_request_in_app: 0 })

    assert_enqueued_with(job: SendFriendRequestTrackerJob) do
      FriendRequest.create(requester: requester, requestee: requestee)
    end
  end
end
