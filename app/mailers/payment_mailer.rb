# frozen_string_literal: true

class PaymentMailer < ApplicationMailer
  def free_plan_notification(user)
    @user = user
    mail(to: user.email,
         subject: 'Cher Clique free access success')
  end

  def recurrent_payment_error(user)
    @user = user
    mail(to: user.email, subject: 'Your Payment Was Declined — Update Now')
  end

  def cancel_subscription(user)
    @user = user
    mail(to: user.email, subject: '50% off or Confirm Your Cancellation')
  end
end
