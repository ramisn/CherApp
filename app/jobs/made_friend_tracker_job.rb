# frozen_string_literal: true

class MadeFriendTrackerJob < ApplicationJob
  queue_as :default

  def perform(friend_request)
    return unless Rails.env.production? || Rails.env.staging?

    MixpanelTracker.track_event(friend_request.requester.email,
                                'Made a friend',
                                'Friend email': friend_request.requestee.email)
    MixpanelTracker.track_event(friend_request.requestee.email,
                                'Made a friend',
                                'Friend email': friend_request.requester.email)
  end
end
