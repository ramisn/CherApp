# frozen_string_literal: true

class SendEmailJob
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find_by(id: user_id)
    SendWeeklyPropertiesService.new.send_emails(user)
  end
end
