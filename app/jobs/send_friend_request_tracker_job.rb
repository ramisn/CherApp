# frozen_string_literal: true

class SendFriendRequestTrackerJob < ApplicationJob
  queue_as :default

  def perform(friend_request)
    return unless Rails.env.production? || Rails.env.staging?

    MixpanelTracker.track_event(friend_request.requester.email,
                                'Send a friend request',
                                'Requestee email': friend_request.requestee.email)
  end
end
