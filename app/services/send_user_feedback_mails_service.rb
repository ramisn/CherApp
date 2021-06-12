# frozen_string_literal: true

class SendUserFeedbackMailsService
  # Service that will send the respective feedback emails
  # Executed with a cron job with `rake feedback_emails:send_emails`

  def initialize
    @users = User.co_borrower.inside_feedback_plan

    # Can't be a constant because it would be instanciated
    # only the first time, and the dates are moving forward.
    @feedback_steps = [
      30.minutes.ago,
      24.hours.ago,
      48.hours.ago,
      72.hours.ago,
      96.hours.ago
    ]
  end

  def execute
    @feedback_steps.each_with_index do |time, step|
      @users.created_ago(time).with_feedback_plan_on(step).each do |user|
        send_email(user)
      end
    end
  end

  private

  def send_email(user)
    UserSignUpFeedbackMailer.with(user: user).send(user.feedback_plan_step).deliver_now

    user.update(feedback_plan_step: user.feedback_plan_step_before_type_cast + 1)
  end
end
