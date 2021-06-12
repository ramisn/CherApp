# frozen_string_literal: true

class SendFriendRequestNotificationJob < ApplicationJob
  queue_as :default

  def perform(friend_request)
    SendFriendRequestTextMessageService.new(friend_request).execute
    UserAccountMailer.with(user: friend_request.requester, requestee: friend_request.requestee).friend_request.deliver_later
  end
end
