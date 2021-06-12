# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/payment_mailer
class PaymentMailerPreview < ActionMailer::Preview
  def free_plan_notification
    PaymentMailer.free_plan_notification(agent)
  end

  def recurrent_payment_error
    PaymentMailer.recurrent_payment_error(agent)
  end

  def cancel_subscription
    PaymentMailer.cancel_subscription(agent)
  end

  private

  def agent
    User.new(email: 'miguel@cher.app', password: 'Password1', role: :agent, first_name: 'Miguel', last_name: 'Urbina')
  end
end
