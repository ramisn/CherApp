# frozen_string_literal: true

namespace :feedback_emails do
  task send_emails: :environment do
    SendUserFeedbackMailsService.new.execute
  end
end
