# frozen_string_literal: true

namespace :background_check do
  task users_who_requested_background_check: :environment do
    users = User.where(background_check_status: :pending)
    InquiryRequestedMailer.send_pending_requests_csv(users).deliver_now if users.any?
  end
end
