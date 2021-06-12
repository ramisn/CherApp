# frozen_string_literal: true

class SendWeeklyPropertiesService
  def execute
    User.kept.co_borrower.each_with_index { |user, index| SendEmailJob.perform_async(user.id) }
  end

  def send_emails(user)
    properties = TopPropertiesService.new(user).execute
    ActivityMailer.weekly_properties_drip(properties, user).deliver_now
  end
end
